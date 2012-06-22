#!/usr/bin/perl -w
# This perl module is maintained by Rüdiger Beck
# It is Free Software (License GPLv3)
# If you find errors, contact the author
# jeffbeck@web.de  or  jeffbeck@gmx.de


package leovirtstarter;
require Exporter;
use utf8;
use File::Basename;
@ISA = qw(Exporter);

@EXPORT_OK = qw( );
@EXPORT = qw( 
              );
my $on_the_go="-";


# Einlesen der Konfigurationsdatei
my $conf="/etc/leovirtstarter/leovirtstarter.conf";
if (not -e $conf){
    print "ERROR: $conf not found!\n";
    exit;
}
{ package Conf ; do "$conf" 
  || die "Fehler: $conf could not be processed (syntax error?)\n";
  print "$conf processed succesfully\n"; 
}


# moved into the scripts

## Einlesen der Server Konfigurationsdatei
#if (not -e $Conf::common_configuration_file){
#    print "ERROR:  $Conf::common_configuration_file not found!\n";
#    exit;
#}
#{ package ServerConf ; do "$Conf::common_configuration_file" 
#  || die "Fehler:  \n",
#         "  $Conf::common_configuration_file \n",
#         "could not be processed (syntax error?)\n";
#  print "$Conf::common_configuration_file processed succesfully\n"; 
#}

#INFO "Test";



############################################################
# subs
############################################################
#print "leovirtstarter.pm: subs start here \n";


sub  check_options{
   my ($parse_ergebnis) = @_;
   if (not $parse_ergebnis==1){
      my @list = split(/\//,$0);
      my $scriptname = pop @list;
      print "\nYou have made a mistake, when specifying options.\n"; 
      print "See error message above. \n\n";
      print "... $scriptname is terminating.\n\n";
      exit;
   } else {
      print "All options  were recognized.\n";
   }

}



sub test {
    print "Sub test from module leovirtstarter\n";
}





sub show_message_dialog {
    #THIS IS THE MAIN FEATURE OF THE APP:
    #you tell it what to display, and how to display it
    #$parent is the parent window, or "undef"
    #$icon can be one of the following:	a) 'info'
    #					b) 'warning'
    #					c) 'error'
    #					d) 'question'
    #$text can be pango markup text, or just plain text, IE the message
    #$button_type can be one of the following: 	a) 'none'
    #						b) 'ok'
    #						c) 'close'
    #						d) 'cancel'
    #						e) 'yes-no'
    #						f) 'ok-cancel'

    my ($parent,$icon,$text,$button_type) = @_;
 
    my $dialog = Gtk2::MessageDialog->new_with_markup ($parent,
					[qw/modal destroy-with-parent/],
					$icon,
					$button_type,
					sprintf "$text");
		
    # this will typically return certain values depending on the 
    # value of $retval.
    # in this application, we only change the label's value accordingly
    my $retval = $dialog->run;
    #destroy the dialog as it comes out of the 'run' loop	
    $dialog->destroy;
}



sub get_snapshots {
    my ($get_dir) = @_;
    my @snapshots=();
    #print "opening $get_dir\n";
    opendir (DIR, $get_dir) || die $!;
    while( (my $dirname = readdir(DIR))){
        if ($dirname eq "." or $dirname eq ".." ){
	    next;
        }

        print "Processing $dirname\n";
        my $abs_path=$get_dir."/".
                     $dirname."/".$ServerConf::snapshot_file_name;
        if (not -e $abs_path){
            # no snapshot file found/no access to snapshot file 
            next;
        }
        ${snapshots}{$dirname}{'abs_path'}=$abs_path;
        my $abs_dir=$get_dir."/".
                    $dirname;
        ${snapshots}{$dirname}{'abs_dir'}=$abs_dir;

        # filesizes
        my $file_vdi_size=$abs_dir."/filesize.vdi";
        my $file_zipped_size=$abs_dir."/filesize.vdi.zipped";
        my $filesize_vdi=`cat '$file_vdi_size'`;
        chomp($filesize_vdi);
        my $filesize_zipped=`cat '$file_zipped_size'`;
        chomp($filesize_zipped);
        ${snapshots}{$dirname}{'filesize_vdi'}=$filesize_vdi;
        ${snapshots}{$dirname}{'filesize_zipped'}=$filesize_zipped;

        if ($dirname ne $ServerConf::snapshot_default){
            # jump over the default snapshot (appears automagically at second in the list)
            push @snapshots, $dirname;
        }

        # read image.conf
        my $file=$get_dir."/".$dirname."/image.conf";
        if (-e $file){
            open (FILE, $file);
	    while (<FILE>){
               chomp();
               my ($key,$value) = split(/=/);
               # convert unicode to iso
               $value=~s/\303\244/\344/g;# ae
               $value=~s/\303\204/\304/g;# Ae
               $value=~s/\303\266/\366/g;# oe
               $value=~s/\303\226/\326/g;# Oe
               $value=~s/\303\274/\374/g;# ue
               $value=~s/\303\234/\334/g;# Ue
               $value=~s/\303\237/\337/g;# ss

               ${snapshots}{$dirname}{$key}="$value";
               #print "   * Key: $key  --> Value: $value\n";
	    }
        }
    }
    closedir DIR;
    @snapshots = sort @snapshots;
    return @snapshots;
}







# ENDE DER DATEI
# Wert wahr=1 zurückgeben
1;
