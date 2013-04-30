#!/usr/bin/env ruby
# Usage: insert_html.rb <directory>
# Puts text passed to STDIN directly after the <body> HTML tag in all HTML-like
# files in <directory> or any of its subdirectories (recursive).

def printUsage( msg )
  puts msg
  puts "Usage: #{__FILE__} <directory>"
  exit 1
end

if ARGV.length < 1
  printUsage "Please provide a <directory>."
end

path = ARGV[0]
$insert = STDIN.read

def processFolder( dir )
  Dir.foreach( dir ) do |filename|
    next if [".", ".."].include? filename
    path = File.join( dir, filename )
    processFileOrFolder( path )
  end
end

def processFile( file )
  return unless [
    ".htm", ".html", ".php", ".xhtml", ""
  ].include? File.extname( file )

  contents = File.read( file )
  contents.gsub!( /(\<body[^>]*>)/, "\\1 " + $insert )

  f = File.open( file, "w" )
  f.write( contents )
  f.close
  puts "Modified: #{file}"
end

def processFileOrFolder( path )
  if File.directory? path
    processFolder( path )
  else
    processFile( path )
  end
end

processFileOrFolder( path )

