# Задание 1. Yandex Cloud
- Что нужно сделать
- Создать пустую VPC. Выбрать зону.
## Публичная подсеть.
- Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
- Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
## Приватная подсеть.
- Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.
[Teraform]()
- установила
vagrant@vagrant:~$ terraform version
Terraform v1.8.2
on linux_amd64
- создала ключи id_ed25519 и id_ed25519.pub
- развернула terraform apply  ---Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
ssh -i /home/vagrant/.ssh/id_ed25519 ubuntu@158.160.126.20  - подключаемся к ВМ
ubuntu@fhmjpsiimb491p1slsq3:~$ ping google.com  --- запускаем пинг
PING google.com (173.194.221.100) 56(84) bytes of data.
64 bytes from lm-in-f100.1e100.net (173.194.221.100): icmp_seq=1 ttl=58 time=28.2 ms
64 bytes from lm-in-f100.1e100.net (173.194.221.100): icmp_seq=2 ttl=58 time=27.9 ms
64 bytes from lm-in-f100.1e100.net (173.194.221.100): icmp_seq=3 ttl=58 time=27.9 ms
```
![VM]()

```
Проверяем пинг с публичной машины в приватную сеть
ubuntu@fhmjpsiimb491p1slsq3:~/.ssh$ ping 192.168.20.22
PING 192.168.20.22 (192.168.20.22) 56(84) bytes of data.
64 bytes from 192.168.20.22: icmp_seq=1 ttl=61 time=1.20 ms
64 bytes from 192.168.20.22: icmp_seq=2 ttl=61 time=0.418 ms
64 bytes from 192.168.20.22: icmp_seq=3 ttl=61 time=0.399 ms
64 bytes from 192.168.20.22: icmp_seq=4 ttl=61 time=0.480 ms
64 bytes from 192.168.20.22: icmp_seq=5 ttl=61 time=0.590 ms
подключаемся к ВМ из публичной сети
ubuntu@fhmjpsiimb491p1slsq3:~/.ssh$ ssh -i /home/vagrant/.ssh/id_ed25519 ubuntu@192.168.20.22
Warning: Identity file /home/vagrant/.ssh/id_ed25519 not accessible: No such file or directory.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-156-generic x86_64)
```
![Ping]()
