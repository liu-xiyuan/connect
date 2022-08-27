package com.example.connect.common;

public class HidConsts {

    public final static String NAME = "Connect HID";

    public final static String DESCRIPTION = "Mobile controller for computer";

    public final static String PROVIDER = "Mobile Controller";

    // 蓝牙HID键盘的描述
    public final static byte[] DESCRIPTOR = {

            // HID键盘 id: 8
            (byte)5, (byte)1,                         // USAGE_PAGE (Generic Desktop)
            (byte)9, (byte)6,                         // USAGE (Keyboard)
            (byte)161, (byte)1,
            (byte)133, (byte)8,                       //   REPORT_ID (8)
            (byte)5, (byte)7,
            (byte)25, (byte)224,
            (byte)41, (byte)231,
            (byte)21, (byte)0,
            (byte)37, (byte)1,
            (byte)117, (byte)1,
            (byte)149, (byte)8,
            (byte)129, (byte)2,
            (byte)149, (byte)1,
            (byte)117, (byte)8,
            (byte)129, (byte)1,
            (byte)149, (byte)1,
            (byte)117, (byte)8,
            (byte)21, (byte)0,
            (byte)37, (byte)101,
            (byte)5, (byte)7,
            (byte)25, (byte)0,
            (byte)41, (byte)101,
            (byte)129, (byte)0,
            (byte)192,

            // HID手柄 id: 1
            (byte)0x05, (byte)0x01,                    // USAGE_PAGE (Generic Desktop)
            (byte)0x09, (byte)0x04,                    // USAGE (Joystick)
            (byte)0xa1, (byte)0x01,                    // COLLECTION (Application)
            (byte)0x85, (byte)0x01,                    //   REPORT_ID (1)
            (byte)0xa1, (byte)0x00,                    //   COLLECTION (Physical)
            (byte)0x09, (byte)0x30,                    //     USAGE (X)
            (byte)0x09, (byte)0x31,                    //     (Y)
            (byte)0x15, (byte)0x81,                    //     LOGICAL_MINIMUM (-127)
            (byte)0x25, (byte)0x7f,                    //     LOGICAL_MAXIMUM (127)
            (byte)0x75, (byte)0x08,                    //     REPORT_SIZE (8)
            (byte)0x95, (byte)0x02,                    //     REPORT_COUNT (2)
            (byte)0x81, (byte)0x02,                    //     INPUT (Data,Var,Abs)
            (byte)0x05, (byte)0x09,                    //     USAGE_PAGE (Button)
            (byte)0x29, (byte)0x08,                    //     USAGE_MAXIMUM (Button 8)
            (byte)0x19, (byte)0x01,                    //     USAGE_MINIMUM (Button 1)
            (byte)0x95, (byte)0x08,                    //     REPORT_COUNT (8)
            (byte)0x75, (byte)0x01,                    //     REPORT_SIZE (1)
            (byte)0x25, (byte)0x01,                    //     LOGICAL_MAXIMUM (1)
            (byte)0x15, (byte)0x00,                    //     LOGICAL_MINIMUM (0)
            (byte)0x81, (byte)0x02,                    //     Input (Data, Variable, Absolute)
            (byte)0xc0,                          //   END_COLLECTION
            (byte)0xc0,                           //   END_COLLECTION

            // Report ID 3: Advanced buttons
            (byte)0x05, (byte)0x0C,                     // Usage Page (Consumer)
            (byte)0x09, (byte)0x01,                     // Usage (Consumer Control)
            (byte)0xA1, (byte)0x01,                     // Collection (Application)
            (byte)0x85, (byte)0x03,                     //     Report Id (3)
            (byte)0x15, (byte)0x00,                     //     Logical minimum (0)
            (byte)0x25, (byte)0x01,                     //     Logical maximum (1)
            (byte)0x75, (byte)0x01,                     //     Report Size (1)
            (byte)0x95, (byte)0x01,                     //     Report Count (1)

            (byte)0x09, (byte)0xCD,                     //     (Play/Pause)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x0A, (byte)0x83, (byte)0x01,         //     (AL Consumer Control Configuration)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x09, (byte)0xB5,                     //     Usage (Scan Next Track)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x09, (byte)0xB6,                     //     Usage (Scan Previous Track)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)

            (byte)0x09, (byte)0xEA,                     //     Usage (Volume Down)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x09, (byte)0xE9,                     //     Usage (Volume Up)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x09, (byte)0xE2,                     //     Usage (Mute)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0x0A, (byte)0x24, (byte)0x02,         //     Usage (AC Back)
            (byte)0x81, (byte)0x06,                     //     Input (Data,Value,Relative,Bit Field)
            (byte)0xC0,                                 // End Collection
    };

}