# trex-core-emu-docker

## Download and build
```
git clone https://github.com/burryfun/trex-core-emu-docker.git
docker build -t trex-core-emu .
```
## Start container
```
docker run --rm -it --net=host --privileged --cap-add=ALL -v /lib/modules:/lib/modules trex-core-emu
```
## Usage  
### Test NGINX performance, tcp emulation  
Config ipv4_profile.py and nginx_wget.py:  
change mac and ip

### Start traffic for 100 clients  
```
./t-rex-64 -i --astf --emu
./trex-console --emu
```
```
trex> portattr -p 0 --prom on
trex> emu_load_profile -f emu/ipv4_profile.py -t --ns 1 --cl 100
trex> plugins load emu_astf
trex> start -f astf/nginx_wget.py -m 100
```

### PPPoE emulation  
```
./t-rex-64 -i --stl
```
```
python3 start_pppoe
```
