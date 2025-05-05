#   Automatic Arch

This script automatically installs a functional base of Arch Linux for you. Just ensure you're connected to the internet and follow a few simple steps. You can easily customize the script variables to match your needs.

---

##   Requirements

* An active internet connection (check with `ping`)
* Arch Linux live USB or install environment
* Proper keyboard layout set (`loadkeys`)
* Git installed to clone the repository

---

##   Installation Steps

### 🔹 Step 1: Preparation

Check your internet connection:

```bash
ping -c 1 8.8.8.8
```

Set your keyboard layout (optional):

```bash
loadkeys en    # or es, de, etc.
```

---

### 🔹 Step 2: Clone the Repository

Install Git if you don't have it:

```bash
pacman -Sy git
```

Clone this repository:

```bash
git clone https://github.com/Casey-Lux/automaticArch
```

---

### 🔹 Step 3: Run the Automatic Script

Enter the directory:

```bash
cd automaticArch
```

Make the installer script executable and run it:

```bash
chmod +x archinstaller.sh
./archinstaller.sh
```

---

## 🎉 Done!

Your base Arch system will be installed and ready for you to customize with your preferred desktop environment, drivers, and tools.

---

## 📜 License

This project is licensed under the MIT License. You're free to use, modify, and share it. Happy installing!
