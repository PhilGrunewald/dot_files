" compose mail
     command! Mail e ~/Mail/mutt/template.mail | sav! draft.mail

" send mail
     command! Send call VimMail('plain')
     fu! VimMail(format)
         " send email as plain text (unless format == 'html')
        "/Users/pg/Library/Containers/com.apple.mail/Data/Library/SyncedPreferences/com.apple.mail-com.apple.mail.recents.plist
        ".addresses
        let sentMessageFile = '~/Mail/mutt/sent/' . strftime("%y_%m_%d_%H_%M") . '.mail'
        execute 'silent w! ' . sentMessageFile
        let Message=""
        let SendTo=""
        let SendCC=""
        let Attach=""
        let Subject=""
        let sendCommand=""
        call CleanRTF()
    
        " Bcc: do before saving to remove from file
        let @m=""
        silent! g/^Bcc:/y m
        let SendBcc=substitute(@m,"^Bcc:","","g")
        let SendBcc= "-b \"" . SendBcc . "\""
        let SendBcc=substitute(SendBcc,"","","g")
        silent! g/^Bcc:/d
    
        let sentMessageFile = '~/Mail/mutt/sent/' . strftime("%y_%m_%d_%H_%M") . '.mail'
        execute 'silent w! ' . sentMessageFile

        " To: is optional - first line is treated as address in any case
        let temp=@m
        let @m=""
        silent! 1g/@/y m
        let SendTo=@m
        let SendTo=substitute(SendTo,"^To:","","g")
        let SendTo=substitute(SendTo,"","","g")
        let SendTo=substitute(SendTo," ","","g")
        silent! 1g/@/d
    
        " Cc: is required for this line to be treated as Cc
        let @m=""
        silent! 1g/^Cc:/y m
        let SendCc=substitute(@m,"^Cc:","","g")
        let SendCc= "-c \"" . SendCc . "\""
        let SendCc=substitute(SendCc,"","","g")
        silent! 1g/^Cc:/d

        " Subject:
        let Subject=getline(1)
        let Subject=substitute(Subject,"^Subject:","","g")
    
        "get Attachments (leading ^Attach:)
        let @m=""
        silent! %s/^Attach: /-a /
        " every new line is a new attachement - with a leading '-a'
        silent! g/^-a \//y M
        silent! g/^-a \//d
        let @m=substitute(@m,"\n"," ","g")
        let @m=substitute(@m,"^,","","")
        let Attach=substitute(@m,",$","","")
    
        let @m=temp
    
        "get Message
        let outFile='~/Mail/mutt/out.mail'
        silent 2,$w! ~/Mail/mutt/out.mail
    
        let html = ''
        if (a:format == 'html')
            let html = '-e "set content_type=text/html" '
        endif
    
        let sendCommand = '!mutt '.html.' -s "'. Subject.'" ' . SendTo  .' '. SendCc . ' ' . SendBcc . ' ' . Attach .' < ' . outFile
    
        let sendCommand = substitute(sendCommand,"\n","","g")
        execute 'silent! ' sendCommand
        echo "Message '" . Subject . "' sent to " . SendTo
        " open the editable file again
        execute 'silent e! ' sentMessageFile
     endfu
    fu! CleanRTF()
       silent! %s/Ê/ /g
       silent! %s/á/- /g
       silent! %s//r/g
       silent! %s/Õ/'/g
       silent! %s/Õ/'/g
       silent! %s/É/...Q/g
       silent! %s/Ð/-/g
       silent! %s//ü/g
    endfu
