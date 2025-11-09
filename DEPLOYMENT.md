# 🚀 GitHub Deployment - Schritt-für-Schritt Anleitung

## ✅ Dein Code ist bereit!

Alles ist vorbereitet und committet. Jetzt musst du nur noch:

---

## 📤 **Schritt 1: GitHub Repository erstellen**

### Option A: Via GitHub Website (Empfohlen)

1. **Öffne:** https://github.com/new

2. **Fülle aus:**
   - Repository Name: `medphysik-app`
   - Description: `Medizinphysik Berechnungs-App - Flutter Web App für Dosimetrie und Strahlentherapie`
   - ✅ Public
   - ❌ **NICHT** "Add a README file" anklicken
   - ❌ **NICHT** ".gitignore" auswählen
   - ❌ **NICHT** "Choose a license" auswählen

3. **Klicke:** "Create repository"

4. **Kopiere die URL** die angezeigt wird (z.B. `https://github.com/DEIN-USERNAME/medphysik-app.git`)

---

## 📡 **Schritt 2: Code hochladen**

**Führe diese Befehle im Terminal aus:**

```powershell
# Wechsle ins Projektverzeichnis
cd C:\Users\medvi\Documents\EU61131\medphysik_app

# Füge GitHub Remote hinzu (ERSETZE MIT DEINER URL!)
git remote add origin https://github.com/DEIN-USERNAME/medphysik-app.git

# Pushe Code zu GitHub
git push -u origin main
```

**Bei der ersten Anfrage:**
- GitHub fordert Login an
- Verwende deinen GitHub Username
- Verwende ein **Personal Access Token** als Passwort

---

## 🔑 **Schritt 3: Personal Access Token erstellen (falls nötig)**

Falls Git nach Passwort fragt:

1. Gehe zu: https://github.com/settings/tokens
2. Klicke: "Generate new token (classic)"
3. Name: `Flutter App Deployment`
4. Expiration: `90 days`
5. Scopes: ✅ `repo` (alle repo-Optionen)
6. Klicke: "Generate token"
7. **KOPIERE DEN TOKEN** (wird nur einmal angezeigt!)
8. Verwende Token als Passwort beim `git push`

---

## 🌐 **Schritt 4: GitHub Pages aktivieren**

1. **Gehe zu deinem Repository** auf GitHub
   `https://github.com/DEIN-USERNAME/medphysik-app`

2. **Klicke** "Settings" (oben rechts)

3. **Klicke** "Pages" (links im Menü)

4. **Unter "Build and deployment":**
   - Source: Wähle `GitHub Actions`
   - (Der Workflow ist bereits in `.github/workflows/deploy.yml` vorhanden!)

5. **Klicke** "Save"

---

## ⏱️ **Schritt 5: Warte auf Deployment**

1. **Gehe zu** "Actions" Tab (oben)
2. Du siehst den Workflow "Deploy to GitHub Pages" laufen
3. Warte ~2-3 Minuten
4. ✅ Grüner Haken = Fertig!

---

## 🎉 **Deine App ist live!**

Nach erfolgreichem Deployment ist deine App verfügbar unter:

```
https://DEIN-USERNAME.github.io/medphysik-app/
```

### 📱 Auf dem Smartphone öffnen:

1. Öffne Chrome/Safari auf deinem Handy
2. Gehe zur URL
3. Klicke "Zu Startbildschirm hinzufügen"
4. Die App verhält sich wie eine native App!

---

## 🔄 **Updates veröffentlichen**

Wenn du Code änderst:

```powershell
cd C:\Users\medvi\Documents\EU61131\medphysik_app

# Änderungen hinzufügen
git add .

# Commit erstellen
git commit -m "Beschreibung deiner Änderung"

# Hochladen
git push

# GitHub Actions deployed automatisch!
```

---

## 📊 **Repository-Statistiken anzeigen**

Füge diese Badges zu deinem README.md hinzu:

```markdown
![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue)
![Dart](https://img.shields.io/badge/Dart-3.5.4-blue)
![GitHub Pages](https://img.shields.io/badge/Deployed-GitHub%20Pages-success)
```

---

## 🆘 **Troubleshooting**

### Problem: "Permission denied"
**Lösung:** Erstelle Personal Access Token (siehe Schritt 3)

### Problem: "remote origin already exists"
**Lösung:** 
```powershell
git remote remove origin
git remote add origin https://github.com/DEIN-USERNAME/medphysik-app.git
```

### Problem: "Failed to build"
**Lösung:** 
- Prüfe "Actions" Tab für Fehlermeldungen
- Stelle sicher dass `pubspec.yaml` korrekt ist

### Problem: "404 Not Found" nach Deployment
**Lösung:**
- Warte weitere 2-3 Minuten
- Stelle sicher GitHub Pages aktiviert ist (Settings → Pages)
- Prüfe ob der richtige Branch deployed wird

---

## 📋 **Checkliste**

- [ ] GitHub Repository erstellt
- [ ] `git remote add origin` ausgeführt
- [ ] `git push -u origin main` erfolgreich
- [ ] GitHub Pages auf "GitHub Actions" gesetzt
- [ ] Workflow in "Actions" läuft
- [ ] App ist online erreichbar
- [ ] Auf Smartphone getestet

---

## 🎯 **Nächste Schritte**

Nach erfolgreichem Deployment:

1. ✅ App auf Smartphone testen
2. ✅ Link in deinen Lebenslauf aufnehmen
3. ✅ Repository in Bewerbungen zeigen
4. ✅ App mit Kollegen/Professoren teilen

---

## 💡 **Pro-Tipps**

1. **Custom Domain** (optional):
   - Kaufe Domain (z.B. medphysik-rechner.de)
   - In Settings → Pages → Custom domain
   - Füge CNAME hinzu

2. **Analytics hinzufügen**:
   - Google Analytics für Besucherstatistiken
   - Zeigt Professionalität

3. **README verbessern**:
   - Füge Screenshots hinzu
   - Beschreibe Features ausführlich
   - Zeigt bei Bewerbungen gut aus!

---

**Viel Erfolg! 🚀**

Bei Fragen: Schau in die GitHub Documentation oder frag mich!
