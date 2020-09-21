//
//  Constants.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

import Foundation
import UIKit

struct OnBoardList {
    static let icon = [UIImage(named: "Heart"), UIImage(named: "Call"), UIImage(named: "share"), UIImage(named: "Email")]
    static let title = ["Vitals with alerts and trends", "Ask general", "Share data", "Support"]
    static let subtitle = ["Heart, Respiration, Oxygen, Sleep Quality & BP", "Ask general health of the user", "Share data using the preferred intent", "Call, Email, WhatsApp"]
}

struct UserDefaultKey {
    static let didCompleteSplash = "didCompleteSplash"
    static let todaysAnswer = "todaysAnswer"
}

let appThemeColor = UIColor.themeConvertor(dark: "#0E0D1D", light: "#0E0D1D")

struct RangeColors {
    static let healthy = UIColor(hexString: "#2CBE61")
    static let borderLine = UIColor(hexString: "#FF9F31")
    static let unhealthy = UIColor(hexString: "#FF5757")
}

let supportCC = "+91"
let supportNumber = "8884436933"
let supportEmail = "support@dozee.io"
let subjectLine =  " - Need support with my Dozee app"

/*----------------    Heart Rate     ------------------*/
//            Healthy Range (Green) - Average 55-65 bpm
//            Borderline Range (Orange) - Average 45-54 bpm & 66-75 bpm
//            Unhealthy Range (Red) - Average <45 bpm & >75 bpm

func calculateHeartRate(_ heartRate: Int) -> UIColor {
    if heartRate > 0 {
        if heartRate >= 55 && heartRate <= 65 {
            return RangeColors.healthy
        }else if heartRate >= 45 && heartRate <= 54 || heartRate >= 66 && heartRate <= 75 {
            return RangeColors.borderLine
        }else if heartRate < 45 || heartRate > 75 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

/*----------------    Breath Rate     ------------------*/
//            Healthy Range (Green) - Average 8-12 rpm
//            Borderline Range (Orange) - Average 13-15 rpm
//            Unhealthy Range (Red) - Average <8 rpm & >15 rpm

func calculateBreathRate(_ breathRate: Int) -> UIColor {
    if breathRate > 0 {
        if breathRate >= 8 && breathRate <= 12 {
            return RangeColors.healthy
        }else if breathRate >= 13 && breathRate <= 15 {
            return RangeColors.borderLine
        }else if breathRate < 8 || breathRate > 15 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

/*----------------    Oxygen Saturation     ------------------*/
//            Healthy Range (Green) - Average >94%
//            Borderline Range (Orange) - Average 90-94%
//            Unhealthy Range (Red) - Average <90%

func calculateOxygenSaturation(_ oxygenRate: Int) -> UIColor {
    if oxygenRate > 0 {
        if oxygenRate > 94 {
            return RangeColors.healthy
        }else if oxygenRate >= 90 && oxygenRate <= 94 {
            return RangeColors.borderLine
        }else if oxygenRate < 90 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

/*----------------    BP     ------------------*/
                 //Average Systolic               //Average Diastolic
//Healthy Range (Green)     //<130 mmHg            //and     //<80 mmHg
//Borderline Range (Orange) //130-140 mmHg        //and/or   //80-90 mmHg
//Unhealthy Range (Red)     //>140 mmHg             //or     //>90 mmHg

func calculateBP(_ systolic: Int, _ diastolic: Int) -> UIColor {
    if systolic > 0 && diastolic > 0 {
        if systolic < 130 && diastolic < 80 {
            return RangeColors.healthy
        } else if (systolic >= 130 && systolic <= 140) || (diastolic >= 80 && diastolic <= 90) {
            return RangeColors.borderLine
        } else if systolic > 140 || diastolic > 90 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

            /*---------------   Sleep Score  --------------*/
//            Healthy Range (Green) - >80
//            Borderline Range (Orange) - 70-79
//            Unhealthy Range (Red) - <70

func calculateSleepScore(_ sleepScore: Int) -> UIColor {
    if sleepScore > 0 {
        if sleepScore >= 80 {
            return RangeColors.healthy
        }else if sleepScore >= 70 && sleepScore <= 79 {
            return RangeColors.borderLine
        }else if sleepScore < 70 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

            /*-----------------      Recovery       --------------*/
//            Healthy Range (Green) - >90%
//            Borderline Range (Orange) - 75-89%
//            Unhealthy Range (Red) - <75%

func calculateRecoveryRate(_ recovery: Int) -> UIColor {
    if recovery > 0 {
        if recovery >= 90 {
            return RangeColors.healthy
        }else if recovery >= 75 && recovery <= 89 {
            return RangeColors.borderLine
        }else if recovery < 75 {
            return RangeColors.unhealthy
        }
    }
    return UIColor.clear
}

struct HeartRateContent {
    static let content = "The heart rate is one of the ‘vital signs,’ or the important indicators of health in the human body. It measures the number of times that the heart contracts or beats per minute. The speed of the heartbeat varies as a result of physical activity, threats to safety, and emotional responses. The resting heart rate refers to the heart rate when a person is at rest.\n\n"
    
    static let ranges = "Healthy Range -\nAverage 55 - 65 bpm\n\nBorderline Range -\nAverage 45 - 54 bpm & 66 - 75 bpm\n\nUnhealthy Range -\nAverage < 45 bpm & > 75 bpm"
}

struct BreathRateContent {
    static let content = "The Respiration Rate is another ‘Vital Sign’ which is one of the most important indicators of health in the human body. Respiration rate is reported in respirations (breaths) per minute. Each respiration has two phases: Inhalation and exhalation. During inhalation, oxygen is brought into the lungs from where it is transported throughout the body via the bloodstream. During exhalation, carbon dioxide is eliminated.\n\n"
    
    static let ranges = "Healthy Range -\nAverage 8 - 12 rpm\n\nBorderline Range -\nAverage 13 - 15 rpm\n\nUnhealthy Range -\nAverage < 8 rpm & > 15 rpm"
}

struct OxygenSaturationContent {
    static let content = "Oxygen saturation refers to the extent to which hemoglobin is saturated with oxygen. Hemoglobin is an element in your blood that binds with oxygen to carry it through the bloodstream to the organs, tissues, and cells of your body. It is an important parameter for managing patients in a clinical setup.\n\n"
    
    static let ranges = "Healthy Range -\nAverage > 94 %\n\nBorderline Range -\nAverage 90 - 94 %\n\nUnhealthy Range -\nAverage < 90 %"
}

struct BloodPressureContent {
    static let content = "Blood pressure (BP) is the pressure of circulating blood against the walls of blood vessels. Most of this pressure results from the heart pumping blood through the circulatory system. When used without qualification, the term 'blood pressure' refers to the pressure in the large arteries. Blood pressure is usually expressed in terms of the systolic pressure (maximum pressure during one heartbeat) over diastolic pressure(minimum pressure between two heartbeats) in the cardiac cycle. It is measured in millimeters of mercury (mmHg) above the surrounding atmospheric pressure.\n\n"
    
    static let ranges = "Range - Average Systolic and Average Diastolic\nHealthy Range -\nAverage < 130 mmHg and < 80 mmHg\n\nBorderline Range -\nAverage 130 - 140 mmHg and/or 80 - 90 mmHg\n\nUnhealthy Range -\nAverage > 140 mmHg or > 90 mmHg"
}

struct SleepScoreContent {
    static let content = "Sleep is a complex process of the body. Contrary to the popular belief that the brain and body shut down during sleep, both go through several processes to ensure adequate recovery — from burning calories to clearing neurotoxins and more. Most healthy adults need 7-9 hours of sleep as per NIH, USA. Dozee’s sleep score quantifies the efficacy of your sleep by measuring several parameters related to your sleep including body vitals, sleep routine, composition of sleep, and restfulness among others.\n\n"
    
    static let ranges = "Healthy Range -\n> 80\n\nBorderline Range -\n70 - 79\n\nUnhealthy Range -\nAverage < 70"
}

struct RecoveryContent {
    static let content = "Stress is the body's response to anything that moves it away from being ‘Normal’ or ‘Healthy’. Stress hence is much more than the mental stress how we perceive it. It can be physical, hormonal, digestive, environmental, and mental. Recovery Score enables you to track the effectiveness of your sleep to help you recover from the stress that you accumulate during the day. High recovery levels are excellent indicators of good health.\n\n"
    
    static let ranges = "Healthy Range -\n> 90 %\n\nBorderline Range -\n75 - 89 %\n\nUnhealthy Range -\nAverage < 75 %"
}
