#!/usr/bin/python3

import unittest

import pandas as pd
import numpy as np

import features


class StartVoltageTestCase(unittest.TestCase):

    def setUp(self):
        self.voltage_start_first = pd.Index(np.linspace(start=4.2, stop=2.7, num=1000), name="Voltage_measured")
        self.voltage_start_first_value = 4.2

        self.voltage_start_not_first = pd.Index([4.1, 4.2, 4.15, 4.1, 4.0, 3.95], name="Voltage_measured")
        self.voltage_start_not_first_value = 4.2

    def testFirstVoltage(self):
        result = features.get_start_voltage(self.voltage_start_first)
        assert result == self.voltage_start_first_value, f"Incorrect start voltage received: {result}, correct value is: {self.voltage_start_first_value}"

    def testNotFirstVoltage(self):
        result = features.get_start_voltage(self.voltage_start_not_first)
        assert result == self.voltage_start_not_first_value, f"Incorrect start voltage received: {result}, correct value is: {self.voltage_not_first_value}"


class StopVoltageTestCase(unittest.TestCase):

    def setUp(self):
        self.voltage_stop_last = pd.Index(np.linspace(start=4.2, stop=2.7, num=1000), name="Voltage_measured")
        self.voltage_stop_last_value = 2.7

        self.voltage_stop_not_last = pd.Index([4.1, 4.2, 4.1, 4.0, 3.95, 3.6, 3.4, 3.0, 3.2, 3.0, 2.8, 2.6, 2.5, 2.7, 2.8], name="Voltage_measured")
        self.voltage_stop_not_last_value = 2.5

    def testFirstVoltage(self):
        result = features.get_stop_voltage(self.voltage_stop_last)
        assert result == self.voltage_stop_last_value, f"Incorrect stop voltage received: {result}, correct value is: {self.voltage_stop_last_value}"

    def testNotFirstVoltage(self):
        result = features.get_stop_voltage(self.voltage_stop_not_last)
        assert result == self.voltage_stop_not_last_value, f"Incorrect stop voltage received: {result}, correct value is: {self.voltage_stop_not_last_value}"


class CurrentPeakToPeakTestCase(unittest.TestCase):

    def setUp(self):
        self.current = pd.Index([0, -0.25, -2, -2, -2, -2, -0.25, 0], name="Curent_measured")
        self.time = pd.Index([0, 1, 2, 3, 4, 5, 6, 7], name="Time")
        self.expected = 4 # 6 - 2 = 4

    def testCurrentTimeSaveValueRange(self):
        result = features.get_current_ptp(self.current, self.time)
        assert result == self.expected, f"Incorrect current peak to peak time received: {result}, correct value is: {self.expected}"


if __name__ == "__main__":
    start_voltage_suite = unittest.makeSuite(StartVoltageTestCase, "test")
    stop_voltage_suite = unittest.makeSuite(StopVoltageTestCase, "test")
    current_ptp_suite = unittest.makeSuite(CurrentPeakToPeakTestCase, "test")

    runner = unittest.TextTestRunner()

    runner.run(start_voltage_suite)
    runner.run(stop_voltage_suite)
    runner.run(current_ptp_suite)