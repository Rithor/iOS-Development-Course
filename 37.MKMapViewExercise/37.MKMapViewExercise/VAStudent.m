//
//  VAStudent.m
//  31 - 32.UITableViewEditing.Exercise
//
//  Created by Vitaliy on 27/04/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAStudent.h"

@interface VAStudent ()

@end

static NSString *maleFirstNameString = @"Фатей-Вячеслав-Иакинф-Онуфрий-Мамант-Еремей-Прохор-Козьма"
                                                "-Мариан-Севир-Акила-Александр-Антонин-Сисой-Диодор-Марин"
                                                "-Аркадий-Моисей-Рюрик-Ангелин";
static NSString *maleLastNameString = @"Вязмитинов-Нечаев-Шепелев-Шиферов-Тютчев-Ипатьев-Лихарев-Варпаховский"
                                                "-Акулов-Хлебников-Ловенецкий-Болотин-Доможиров-Бобынин"
                                                "-Лукин-Соловцов-Щепотьев-Дубасов-Дьяченко-Епанчин";
static NSString *femaleFirstNameString = @"Берта-Радмила-Эльвира-Эмма-Аквилина-Неонилла-Феоктиста"
                                                "-Нинель-Томила-Ангелина-Макария-Артемия-Валерия-Горислава"
                                                "-Параскева-Радмила-Галина-Матрона-Василиса-Неонилла";
static NSString *femaleLastNameString = @"Могилянская-Алмазова-Карякина-Ровинская-Хрипунова-Щербань"
                                                "-Любавская-Таубе-Зыбина-Карабчевская-Есаулова-Байчурова-Ширяй"
                                                "-Гурьева-Бородина-Руликовская-Хрипунова-Хилчевская-Левкович-Андреянова";

@implementation VAStudent

+ (VAStudent *)randomStudentWithCoordinatesNearby:(CLLocationCoordinate2D)coordinate {
    
    VAStudent *student = [[VAStudent alloc] init];
    
    student.gender = arc4random() % 2 ? VAStudentGenderMale : VAStudentGenderFemale;
    
    NSArray *firstNameArray = [NSArray array];
    NSArray *lastNameArray = [NSArray array];
    NSArray *avatarImagesArray = [NSArray array];
    
    if (student.gender == VAStudentGenderMale) {
        firstNameArray = [student createArrayFromString:maleFirstNameString];
        lastNameArray = [student createArrayFromString:maleLastNameString];
        avatarImagesArray = [student arrayWithAvatarImageForGender:VAStudentGenderMale];
    } else {
        firstNameArray = [student createArrayFromString:femaleFirstNameString];
        lastNameArray = [student createArrayFromString:femaleLastNameString];
        avatarImagesArray = [student arrayWithAvatarImageForGender:VAStudentGenderFemale];
    }
    student.firstName = [firstNameArray
                         objectAtIndex:arc4random() % [firstNameArray count]];
    student.lastName = [lastNameArray
                        objectAtIndex:arc4random() % [lastNameArray count]];
    student.avatarImage = [avatarImagesArray
                           objectAtIndex:arc4random() % [avatarImagesArray count]];
    
    NSDate *randomDate = [NSDate
                          dateWithTimeInterval:arc4random_uniform(7 * 365 * 24 * 60 * 60)
                          sinceDate:[NSDate dateWithTimeIntervalSinceNow:
                                     - (25 * 365 * 24 * 60 * 60)]];
    student.birthday = randomDate;
    
    CLLocationCoordinate2D studentCoordinate;
    
    double latitudeOffset = (double)(arc4random() % 11000 + 10) / 100000;
    double longitudeOffset = (double)(arc4random() % 11000 + 10) / 100000;
    
    studentCoordinate.latitude = arc4random() % 2 ? (coordinate.latitude + latitudeOffset) : (coordinate.latitude - latitudeOffset);
    studentCoordinate.longitude = arc4random() % 2 ? (coordinate.longitude + longitudeOffset) : (coordinate.longitude - longitudeOffset);
    
    student.coordinate = studentCoordinate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *birthdayYear = [calendar components:NSCalendarUnitYear fromDate:student.birthday];
    
    student.title = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    student.subtitle = [NSString stringWithFormat:@"%i", (int)birthdayYear.year];
    return student;
}

- (NSArray *)createArrayFromString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"-"];
    return array;
}

- (NSArray *)arrayWithAvatarImageForGender:(VAStudentGender)gender {
    
    UIImage *male_01Image = [UIImage imageNamed:@"male_01.png"];
    UIImage *male_02Image = [UIImage imageNamed:@"male_02.png"];
    UIImage *male_03Image = [UIImage imageNamed:@"male_03.png"];
    UIImage *male_04Image = [UIImage imageNamed:@"male_04.png"];
    UIImage *male_05Image = [UIImage imageNamed:@"male_05.png"];
    UIImage *male_06Image = [UIImage imageNamed:@"male_06.png"];
    UIImage *male_07Image = [UIImage imageNamed:@"male_07.png"];
    UIImage *male_08Image = [UIImage imageNamed:@"male_08.png"];
    UIImage *male_09Image = [UIImage imageNamed:@"male_09.png"];
    UIImage *male_010Image = [UIImage imageNamed:@"male_010.png"];
    
    UIImage *female_01Image = [UIImage imageNamed:@"female_01.png"];
    UIImage *female_02Image = [UIImage imageNamed:@"female_02.png"];
    UIImage *female_03Image = [UIImage imageNamed:@"female_03.png"];
    UIImage *female_04Image = [UIImage imageNamed:@"female_04.png"];
    UIImage *female_05Image = [UIImage imageNamed:@"female_05.png"];
    UIImage *female_06Image = [UIImage imageNamed:@"female_06.png"];
    UIImage *female_07Image = [UIImage imageNamed:@"female_07.png"];
    UIImage *female_08Image = [UIImage imageNamed:@"female_08.png"];
    UIImage *female_09Image = [UIImage imageNamed:@"female_09.png"];
    UIImage *female_010Image = [UIImage imageNamed:@"female_010.png"];
    
    if (gender == VAStudentGenderMale) {
        NSArray *maleAvatarImagesArray = @[male_01Image, male_02Image, male_03Image, male_04Image,
                                           male_05Image, male_06Image, male_07Image, male_08Image,
                                           male_09Image, male_010Image];
        return maleAvatarImagesArray;
    } else {
        NSArray *femaleAvatarImagesArray = @[female_01Image, female_02Image, female_03Image, female_04Image,
                                             female_05Image, female_06Image, female_07Image, female_08Image,
                                             female_09Image, female_010Image];
        return femaleAvatarImagesArray;
    }
}

@end
