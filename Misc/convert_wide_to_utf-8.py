import argparse

def convert_wide_to_utf(filename, outfile):
	with open(filename,"rb") as f:
		widedata = f.read()

	print(f"[+] Processesing {filename}")
	normalized_data = widedata.decode("utf-16").encode("utf-8")

	with open(outfile, "wb") as f:
		f.write(normalized_data)

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Converts widestring data into utf-8')
	parser.add_argument('--filename', help='input file', required=False)
	parser.add_argument('--outfile', help='output file', required=False)
	args = parser.parse_args()

	if args.filename and args.outfile:
		convert_wide_to_utf(args.filename,args.outfile)
