#Cinco Cleanup Guideline
1. src-gen und xtend-gen Ordner in Cinco löschen.
1. plugin.xml, plugin.properties, jabc.project löschen.
1. Alle generierten Projekte löschen (auch Inhalte auf der Platte!).
1. Cinco schließen.
1. git checkout info.scce.cinco.product.autoDSL/META-INF/MANIFEST.MF ausführen oder Änderungen an der Datei ggf. in GUI-Tool verwerfen.
1. Cinco starten. Jetzt sollte alles fehlerfrei neu generiert werden.

Die MANIFEST.MF-Datei im Git ist eine Minimalversion ohne projektspezifische Abhängigkeiten etc. - sie sollte daher nie committet werden. Falls Git sie trotzdem zum Commit vormerkt (im Ignore steht sie schon, aber sie soll ja nicht ganz gelöscht werden), kann dies mit dem Befehl "git update-index --assume-unchanged info.scce.cinco.product.autoDSL/META-INF/MANIFEST.MF" unterbunden werden.
