make
./mobilang < test.xml > ast.txt
sudo python3 ./txt_to_diag.py ast.txt dot.txt
