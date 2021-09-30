# trex-core-emu-docker

## Download and build
```
git clone https://github.com/burryfun/trex-core-emu-docker.git
docker build -t trex-core-emu .
```

## Usage  
### Test NGINX performance, tcp emulation  
Config ipv4_profile.py and nginx_wget.py:  
change mac and ip

### Start traffic with client pool-ip [192.168.1.100-192.168.1.199]  
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
./trex-console
```
```
python3 start_pppoe
```