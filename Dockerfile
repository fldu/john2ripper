FROM fedora:latest as builder
LABEL Florian Dubourg <florian@dubourg.lu> 
RUN dnf update -y 
RUN dnf install -y git make gcc openssl-devel
RUN dnf install -y yasm gmp-devel libpcap-devel bzip2-devel
RUN dnf clean all 
RUN git clone https://github.com/magnumripper/JohnTheRipper -b bleeding-jumbo john
RUN cd /john/src && ./configure && make && make -sj4
RUN cd /john/run && ./john --test=0
WORKDIR /john

FROM fedora:latest
LABEL Florian Dubourg <florian@dubourg.lu>
RUN useradd -m john
COPY --from=builder /john/run/ /home/john
RUN chmod 755 /home/john/john
USER john
WORKDIR /home/john
RUN /home/john/john --test=0
