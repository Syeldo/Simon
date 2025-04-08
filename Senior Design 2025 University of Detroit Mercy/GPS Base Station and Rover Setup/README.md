# GPS Base Station and Rover Setup – SparkFun ZED-F9P

This repository includes all the configuration files and resources I used to set up the SparkFun ZED-F9P GPS units as a Base Station and Rover system for accurate navigation. These GPS modules use Real-Time Kinematic (RTK) positioning, which allows for centimeter-level accuracy. That level of precision is especially useful for projects involving robotics, surveying, or anything that requires exact location data. I used u-blox’s U-Center software to configure the GPS units and customize their communication settings to make sure the RTK setup worked correctly.

## Hardware Setup

After loading the configuration files onto each GPS unit, I set one up as the roving base station and the other as the rover. For the connection to work properly:

- Connect **TX2 on the Base** to **RX2 on the Rover**  
- Connect **RX2 on the Base** to **TX2 on the Rover**  
- Connect **GND** on both units together  
- Ensure **both GPS units are powered**

This wiring setup allows the base station to send RTCM correction messages to the rover through UART communication, which helps the rover achieve a much more accurate RTK position fix.

## U-Center Installation and Configuration (on Linux using Wine)

To upload the configuration files, I used the [U-Center software](https://www.u-blox.com/en/product/u-center) from u-blox. Since U-Center is a Windows-only application, I ran it on my Linux machine using Wine. Below are the steps I followed to install and run U-Center:

### Step 1: Install Wine
```bash
sudo apt update
sudo apt install wine64
```

### Step 2: Download and Run U-Center Installer
```bash
wget https://www.u-blox.com/sites/default/files/u-centersetup.exe
wine u-centersetup.exe
```

### Step 3: Launch U-Center
```bash
wine ~/.wine/drive_c/Program\ Files\ \(x86\)/u-blox/u-center/u-center.exe
```

Once U-Center was open, I connected the GPS unit to my computer via USB, selected the correct COM port from the toolbar, and used the **Configuration View** to load and send the correct settings to each unit. It’s important to send the Base and Rover configuration files to the right devices, as each has slightly different parameters. After uploading, I saved the configuration to flash memory to make the settings persist after a reboot.

## Getting a Fix

Once everything is configured and wired correctly, placing the modules outdoors with a clear view of the sky should result in a GNSS fix fairly quickly. If the signal is strong and the RTCM data is being sent and received as expected, the rover should eventually lock onto an RTK fix. These configuration files and instructions are meant to simplify the setup process, avoid common pitfalls, and help others achieve reliable high-accuracy GPS performance.

---

Please me know if you run into any issues or need help troubleshooting!
