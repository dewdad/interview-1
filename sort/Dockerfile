# lightweight ruby image
FROM coopermaa/alpine-ruby:2.2

# Create an app directory where all the stuff can run
RUN mkdir /app
WORKDIR /app

# Copy the code into the container
COPY . ./

# Install rspec (and whatever other gems we might need in the future)
RUN bundle install

# Run the spec tests as part of the build process!
RUN rspec spec/sort_spec.rb

# Run the script, will append any params passed into the docker run command
ENTRYPOINT ["ruby", "main.rb"]
