#!/usr/bin/perl
use warnings;
use strict;

my $filename = 'contacts.txt';
my @contacts;


sub charger_contacts {
    if (-e $filename) {
        open my $fh, '<', $filename or die "Impossible d'ouvrir le fichier pour lecture : $!";
        while (my $line = <$fh>) {
            chomp $line;
            my ($nom_prenom, $tel, $mail) = split /,/, $line;
            my %contact = (
                nom_prenom => $nom_prenom,
                tel => $tel,
                mail => $mail
            );
            push @contacts, \%contact;
        }
        close $fh;
    }
}


sub sauvegarder_contacts {
    open my $fh, '>', $filename or die "Impossible d'ouvrir le fichier pour écriture : $!";
    foreach my $contact (@contacts) {
        print $fh join(',', $contact->{nom_prenom}, $contact->{tel}, $contact->{mail}) . "\n";
    }
    close $fh;
}



print "Cher utilisateur, bienvenue.\n";
charger_contacts();


sub add_contact {
    print "entrez un nom et un prenom\n";
    chomp(my $nom_prenom = <STDIN>);
    print "entrez un numero de téléphone\n";


    while ($nom_prenom eq '') {
        print "Le nom et prénom ne peuvent pas être vides. Veuillez réessayer :\n";
        chomp($nom_prenom = <STDIN>);
    }


    chomp(my $tel = <STDIN>);
    print "entrez une adresse courriel\n";

    while ($tel !~ /^\d+$/) {
        print "Le numéro de téléphone doit contenir uniquement des chiffres. Veuillez réessayer :\n";
        chomp($tel = <STDIN>);
    }

    chomp(my $mail = <STDIN>);

    while ($mail !~ /^[\w\.\-]+@\w+\.\w+$/) {
        print "L'adresse courriel est invalide. Veuillez réessayer :\n";
        chomp($mail = <STDIN>);
    }



    my %contact = (
        nom_prenom => $nom_prenom,
        tel => $tel,
        mail => $mail
    );

    push @contacts, \%contact;
};



sub lister_contacts {
    if (@contacts) {
        print "Liste des contacts :\n";
        foreach my $contact (@contacts) {
            print "Nom : $contact->{nom_prenom}, Telephone : $contact->{tel}, Email : $contact->{mail}\n";
        }
    } else {
        print "Aucun contact à afficher.\n";
    }
}



sub rechercher_contact {
    print "Entrez le nom ou le prénom du contact à rechercher :\n";
    chomp(my $nom_recherche = <STDIN>);

    my $contact_trouve = 0;

    foreach my $contact (@contacts) {
        if (lc $contact->{nom_prenom} eq lc $nom_recherche) {
            print "Contact trouve : \n";
            print "Nom : $contact->{nom_prenom}, Telephone : $contact->{tel}, Email : $contact->{mail}\n";
            $contact_trouve = 1;
            last;
        }
    }

    print "Aucun contact correspondant trouve.\n" unless $contact_trouve;
};


sub supprimer_contact {
    print "Entrez le nom et le prénom du contact à supprimer :\n";
    chomp(my $nom_recherche = <STDIN>);

    my $index = 0;
    my $contact_trouve = 0;


    foreach my $contact (@contacts) {
        if (lc $contact->{nom_prenom} eq lc $nom_recherche) {
            splice(@contacts, $index, 1);
            print "Le contact '$nom_recherche' a été supprimé avec succès.\n";
            $contact_trouve = 1;
            last;
        }
        $index++;
    }
    print "Aucun contact correspondant trouvé.\n" unless $contact_trouve;};



sub afficher_menu {
    print "\nMenu principal :\n";
    print "1. Ajouter un contact\n";
    print "2. Lister les contacts\n";
    print "3. Rechercher un contact\n";
    print "4. Supprimer un contact\n";
    print "5. Quitter\n";
    print "6. Sauvegarder un contact\n";
    print "Choisissez une option : ";
}

sub quitter {
    print "Merci d'avoir utilisé le gestionnaire de contacts. Au revoir !\n";
    exit;
}

#Utilisation :
while (1) {
    afficher_menu();
    chomp(my $choix = <STDIN>);

    if ($choix == 1) {
        add_contact();
    } elsif ($choix == 2) {
        lister_contacts();
    } elsif ($choix == 3) {
        rechercher_contact();
    } elsif ($choix == 4) {
        supprimer_contact();
    } elsif ($choix == 5) {
        quitter();}
    elsif ($choix == 6) {
        sauvegarder_contacts();
    } else {
        print "Choix invalide, veuillez reessayer.\n";
    }
    }


