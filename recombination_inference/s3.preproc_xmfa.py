#!/home-fn/users/nscc1082/software/software/Python-2.7.9/bin/python

# this script 1) reformat the header of xmfa file to strain name only
# 2) filter only alignments that contain all analyzed genomes and stored in *.reformatted
# 3) calculate statistics about each block and stored in file *.stat1 and *.stat2
# 	*.stat1 contains all blocks and *.stat2 contains blocks that involved all analyzed genomes

import xlwt
import os

style_center = xlwt.XFStyle()
style_center.alignment = xlwt.Alignment()
style_center.alignment.horz = xlwt.Alignment.HORZ_CENTER

style_center_bold = xlwt.XFStyle()
style_center_bold.alignment = xlwt.Alignment()
style_center_bold.alignment.horz = xlwt.Alignment.HORZ_CENTER
style_center_bold.font = xlwt.Font()
style_center_bold.font.bold = True


# ----------------------------------------------------
def write2ws(ws, block, num, seqlen, ins_del):
	if block == 0:
		ws.write(block, 0, 'block', style=style_center_bold)
		ws.write(block, 2, '# genomes', style=style_center_bold)
		ws.write(block, 1, '# sites', style=style_center_bold)
		ws.write(block, 3, '# ins/del per site', style=style_center_bold)
		ws.write(block, 4, '# ins/del per site (%)', style=style_center_bold)
	else:
		ws.write(block, 0, block, style=style_center)
	        ws.write(block, 2, num, style=style_center)
        	ws.write(block, 1, seqlen)
		ws.write(block, 3, '%.1f'%ins_del, style=style_center)
		ws.write(block, 4, '%.1f%%'%(float(ins_del)/num*100))

# ----------------------------------------------------


# ----------------------------------------------------

def load_genome_info(filename, ws3, irow):

	f = open(filename)
	contigs = []
	seq = ''
	line = f.readline()
	while line:
		if line.startswith('>'):
			if seq != '':
				contigs.append(seq)
				seq = ''
		else:
			seq += line.replace('\n', '')	
		line = f.readline()

	if seq != '':
		contigs.append(seq)

	genome = filename[2:].split('.')[0].split('/')[1]
	genomelen = 0
	for s in contigs:
		genomelen += len(s)
	ws_row = ws3.row(irow)
	ws_row.write(0, genome, style=style_center)
	ws_row.write(1, genomelen, style=style_center)
	#ws_row.write(1, '%.1f'%(float(genomelen)/1000000))
	ws_row.write(2, len(contigs), style=style_center)
	ws_row.write(3, int(float(genomelen)/len(contigs)+0.5))

# ----------------------------------------------------



# ==========================================================

if __name__ == "__main__":

	infilename = 'roseo_v1_core_500_order.xmfa'
	fa_dir = 'genomic_fasta'  ##where genomic fasta store
	
	f = open(infilename)
	fout = open(infilename+'.reformatted', 'w')
	f_R_input1 = open('all_blocks_len.txt', 'w')
	f_R_input2 = open('cfml_blocks_len.txt', 'w')
	wb = xlwt.Workbook()
	ws1 = wb.add_sheet('all.blocks')
	ws2 = wb.add_sheet('cfml.input.blocks')
	write2ws(ws1, 0, 0, 0, 0)
	write2ws(ws2, 0, 0, 0, 0)
	for i in range(6):
		ws1.col(i).width = 256 * 20
		ws2.col(i).width = 256 * 20


	# get number of genomes
	line = f.readline()
	total = 0
	while line.startswith('#'):
		if fa_dir in line:
			total += 1
		line = f.readline()
	print '# genomes = ', total
	print total


	# loop over xmfa content
	buff = ''
	num = 0
	block = 0
	cfml_block = 0
	genome_dir = []
	while line:
	    if line.startswith('='):
		# calculate number of insertion/deletion of the alignment
		arr = buff.split('\n')
		seqs = []
		for i in range(len(arr)):
			if i%2 == 1:
				seqs.append(arr[i])
		seqlen = len(seqs[0])
		flag_ins_del = [0 for x in range(seqlen)]
		for seq in seqs:
			for i in range(seqlen):
				if seq[i] == '-':
					flag_ins_del[i] += 1
		avg_ins_del_per_site = float(sum(flag_ins_del))/seqlen
		# write to file about all aligned blocks
		block += 1
		write2ws(ws1, block, num, seqlen, avg_ins_del_per_site)	
		f_R_input1.write('%d\n'%seqlen)
		# write to file about blocks that are used as clonalFromeML input
		if num == total:
			cfml_block += 1
			write2ws(ws2, cfml_block, num, seqlen, avg_ins_del_per_site)
			fout.write(buff+'\n=\n') # write to reformatted xmfa file
			f_R_input2.write('%d\n'%seqlen)
		# reset for the next block
		buff = ''
		num = 0
   	    elif line.startswith('> '):
		buff += '>' + line.split()[3].split('.')[0].split("/")[1] + '\n'
		num += 1
	    else:
		tmp = line.replace('\n', '')
		for c in tmp:
			if c not in ['A', 'T', 'C', 'G', 'N', '-', 'X', '?']:
				print c
		buff += tmp
	    line = f.readline()
  	    if line and (line.startswith('>') and buff != ''):
		buff += '\n'

	f.close()
	fout.close()
	f_R_input1.close()
	f_R_input2.close()
	
	ws1.write(0, 7, 'total # sites')
	ws1.write(0, 8, xlwt.Formula('SUM(B2:B'+str(block+1)+')'))
	ws2.write(0, 7, 'total # sites')
        ws2.write(0, 8, xlwt.Formula('SUM(B2:B'+str(cfml_block+1)+')'))

	# plot histogram
	os.system('R CMD BATCH ./plot_hist.R')
	os.system('mv Rplots.pdf alignment_distribution.pdf')

	# genome info
	list_genomes = []
	#os.system('find ./' + fa_dir + '/*.fasta > genomes.txt')
	os.system('find ./' + fa_dir + '/*.fna > genomes.txt')
	f = open('genomes.txt')
	line = f.readline()
	while line:
		list_genomes.append(line.replace('\n', ''))
		line = f.readline()
	f.close()
	os.system('rm genomes.txt')
	# load genome info to a worksheet
	ws3 = wb.add_sheet('genome.info')
	title_row = ws3.row(0)
	title_row.write(0, 'genome', style=style_center_bold)
	title_row.write(1, 'size(bp)', style=style_center_bold)
	title_row.write(2, '#_contigs', style=style_center_bold)
        title_row.write(3, 'avg_contig_size', style=style_center_bold)
	for i in range(len(list_genomes)):
		load_genome_info(list_genomes[i], ws3, i+1)
	# set column width of ws3
        for i in range(10):
                ws3.col(i).width = 256 * 15

	wb.save('stat.xls') 



# =============================================================

