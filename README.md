# pack-libreelec-for-dreambox
Scripts to build Dreambox LibreElec Images on a Linux host

downloads nightly build an makes it bootabel for dreambox bootloader

## Run:
### $ bash mkimgs nightly  
### $ bash mkimgs help     
#### Usage: mkimgs \[targets\]  
         targets: nightly, all, all-local, one, two, play, one-gpt, two-gpt, 
                  one-multi, two-multi, one-local, two-local, play-local, one-gpt-local, 
                 two-gpt-local, one-multi-local, two-multi-local   
         examples: 
          »mkimgs nightly« - packs LibreElec nightly Images for dreambox boot   
          »export LE_BUILD=/path-to-you-LE-root; ./mkimgs all-local« - packs   
                  LibreElec Images from local build for dreambox boot   
          »mkimgs clean« - cleans packing directory 



