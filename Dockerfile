# Use the latest AFL++ image as the base
FROM aflplusplus/aflplusplus:latest as builder

# Update the package list and install necessary packages
RUN apt update && apt install -y git build-essential make gcc libc-dev uthash-dev liblua5.4-dev libpcre2-dev

# Create a user for the build process
RUN useradd -ms /bin/bash mle

# Switch to the mle user
#USER mle

# Copy the current directory contents into the container at /mle
COPY . /mle
#RUN mkdir /bin

# Build the project with static linking
#RUN make -C /mle mle_vendor=1 mle_static=1
RUN make -C /mle
RUN make -C /mle install prefix=/

# Create an inputs directory and add a sample input file
RUN mkdir /inputs && echo foo > /inputs/foo

# Set the default command to run when the container starts
CMD ["afl-fuzz", "-i", "/inputs", "-o", "/output", "-Q", "--", "/bin/mle", "@@"]
