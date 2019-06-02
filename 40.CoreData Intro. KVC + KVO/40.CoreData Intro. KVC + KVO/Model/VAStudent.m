//
//  VAStudent.m
//  40.CoreData Intro. KVC + KVO
//
//  Created by Vitaliy on 02/06/2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

#import "VAStudent.h"

@implementation VAStudent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self
                forKeyPath:@"firstName"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        [self addObserver:self
               forKeyPath:@"lastName"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        [self addObserver:self
               forKeyPath:@"averageGrade"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        [self addObserver:self
               forKeyPath:@"dateOfBirth"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        [self addObserver:self
               forKeyPath:@"gender"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
    }
    return self;
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"firstName"];
    [self removeObserver:self forKeyPath:@"lastName"];
    [self removeObserver:self forKeyPath:@"averageGrade"];
    [self removeObserver:self forKeyPath:@"dateOfBirth"];
    [self removeObserver:self forKeyPath:@"gender"];
}

- (NSString *)stringFromGender:(VAStudentGender)gender {
    NSString *studentGenderString = [[NSString alloc] init];
    switch (gender) {
        case VAStudentGenderUnspecified:
            studentGenderString = @"unspecified";
            break;
        case VAStudentGenderFemale:
            studentGenderString = @"Female";
            break;
        case VAStudentGenderMale:
            studentGenderString = @"Male";
            break;
        default:
            studentGenderString = @"Error for self.student.studentGender";
            break;
    }
    return studentGenderString;
}

-(void)clearAllPropertys {
    
    
    [self willChangeValueForKey:@"firstName"];
    [self willChangeValueForKey:@"lastName"];
    [self willChangeValueForKey:@"averageGrade"];
    [self willChangeValueForKey:@"dateOfBirth"];
    [self willChangeValueForKey:@"gender"];
    _firstName = nil;
    _lastName = nil;
    _averageGrade = 0;
    _dateOfBirth = nil;
    _gender = 0;
    [self didChangeValueForKey:@"firstName"];
    [self didChangeValueForKey:@"lastName"];
    [self didChangeValueForKey:@"averageGrade"];
    [self didChangeValueForKey:@"dateOfBirth"];
    [self didChangeValueForKey:@"gender"];
}


#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    NSLog(@"\nobserveValueForKeyPath: %@\nofObject: %@\nchange: %@", keyPath, object, change);
    
//    id value = [change objectForKey:NSKeyValueChangeNewKey];
    
}
@end
