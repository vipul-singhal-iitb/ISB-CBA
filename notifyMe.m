%notify complete
function []= notifyMe(msg, address)
% Modify these two lines to reflect
% your account and password.
myaddress = 'experimentnotifier@gmail.com';
mypassword = 'notifyme';

setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
dateS = datestr(now);
sendmail(address, [dateS ' Experiment Completed!'], msg);
end