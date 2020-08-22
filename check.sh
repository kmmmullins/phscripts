

for i in {200..255}
do
echo $i
ping -c 3 172.27.161.$i
done
