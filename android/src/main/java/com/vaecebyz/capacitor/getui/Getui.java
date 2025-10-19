package com.vaecebyz.capacitor.getui;

import com.getcapacitor.Logger;

public class Getui {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
