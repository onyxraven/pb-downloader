pb-downloader
=============

Download all your Photobucket pictures, including High Resolution originals!

## About

Photobucket recently made changes to their site that disallows downloading archives of original images of albums.  This is a workaround for that, using acceptable Photobucket methods.

This tool requires a working Photobucket username/password and will not download other people's albums.  

## Installation

### Requirements
* ruby 1.9.3+
* bundler

### Procedure
* Clone the Repo and enter directory
* ```bundle install```

## Usage

```
 % bundle exec ./pb.rb -h
Downloads all files from your photobucket account, preferring highres pictures

Usage:
     --username, -u <s>:   Photobucket username (not email address)
     --password, -p <s>:   Photobucket password
     --base-url, -b <s>:   Photobucket Base URL (view URL to one image, grab
                           the URL up to and including your username, example:
                           http://i323.photobucket.com/albums/s325/username
   --start-path, -s <s>:   Photobucket folder path to start in (default: /)
  --destination, -d <s>:   Folder to put downloads in (default: .)
          --version, -v:   Print version and exit
             --help, -h:   Show this message
```

## Notes

* Uses FTP as the file listing method.  It seems to be somewhat unstable, but restarting the process should work fine.
* Attempts to persuade the Photobucket CDN that it is a proper browser.  If PB changes their detection methods, it could get throttled or blocked
* Highres files are downloaded preferentially by way of ordering and file size.  Its possible this could be fragile for edge cases, YMMV

# License

The MIT License (MIT) http://opensource.org/licenses/MIT

Copyright (c) 2013 Justin Hart (@onyxraven)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

