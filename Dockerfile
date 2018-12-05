FROM ubuntu:latest

RUN apt-get -y update 

RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y wget

RUN cd /root && \
    mkdir otp && \
    cd otp && \
    wget "https://repo1.maven.org/maven2/org/opentripplanner/otp/1.3.0/otp-1.3.0-shaded.jar" && \
    wget "http://www3.unobus.co.jp/opendata/GTFS-2018-04-15.zip" -O unobus.gtfs.zip && \
    wget "http://www.shimoden.net/busmada/opendata/GTFS_JP.zip" -O shimodenbus.gtfs.zip && \
    wget "http://loc.bus-vision.jp/gtfs/ryobi/gtfsFeed" -O ryobibus.gtfs.zip && \
    wget "http://loc.bus-vision.jp/gtfs/okaden/gtfsFeed" -O okadenbus.gtfs.zip && \
    wget "http://loc.bus-vision.jp/gtfs/chutetsu/gtfsFeed" -O chutetsubus.gtfs.zip

RUN cd /root && \
    apt install -y osmctools && \
    wget "http://download.geofabrik.de/asia/japan/chugoku-latest.osm.pbf" && \
    osmconvert chugoku-latest.osm.pbf -b=133.455201,34.274923,134.298740,35.284564 --complete-ways -o=okayama.pbf && \
    mv okayama.pbf otp/ 

ENTRYPOINT java -Xmx5G -jar /root/otp/otp-1.3.0-shaded.jar --build /root/otp/ --inMemory
