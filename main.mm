/*
 * Name: libSimulateTouch
 * Author: iolate <iolate@me.com>
 *
 */

#import <CoreGraphics/CoreGraphics.h>
#import "SimulateTouch.h"

const char * option =
"[Usage]\n\
 1. Touch:\n\
    %s touch x y [orientation]\n\
 2. Swipe:\n\
    %s swipe fromX fromY toX toY [duration(0.3)] [orientation]\n\
 3. Button: \n\
    %s button Type State\n\
 4. home:\n\
 5. lock:\n\
 6. home-double-click:\n\
 7. screenshot:\n\
 \n\
[Example]\n\
   # %s touch 50 100\n\
   # %s swipe 50 100 100 200 0.5\n\
   # %s button 0 1\n\
   # %s button 1 0\n\
   # %s home\n\
   # %s lock\n\
   # %s home-double-click\n\
   # %s screenshot\n\
\n\
[Orientation]\n\
    Portrait:1 UpsideDown:2 Right:3 Left:4\n\
\n\
[Button]\n\
    Power:0 Home:1\n\
\n\
[State]\n\
    Up/Raise:0 Down/Press:1\n\n";
#define PRINT_USAGE printf(option, argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0]);

int main(int argc, char **argv, char **envp) {
    if (argc == 1) {
        PRINT_USAGE;
        return 0;
    }
    
    if (!strcmp(argv[1], "touch")) {
        if (argc != 4 && argc != 5) {
            PRINT_USAGE;
            return 0;
        }
        
        if (argc == 4) {
            int x = atoi(argv[2]);
            int y = atoi(argv[3]);
            
            int r = [SimulateTouch simulateTouch:0 atPoint:CGPointMake(x, y) withType:STTouchDown];
            [SimulateTouch simulateTouch:r atPoint:CGPointMake(x, y) withType:STTouchUp];
        }else if (argc == 5) {
            int px = atoi(argv[2]);
            int py = atoi(argv[3]);
            CGPoint p = CGPointMake(px, py);
            
            CGPoint rp = [SimulateTouch STWindowToScreenPoint:p withOrientation:atoi(argv[4])];
            int r = [SimulateTouch simulateTouch:0 atPoint:rp withType:STTouchDown];
            [SimulateTouch simulateTouch:r atPoint:rp withType:STTouchUp];
        }
        
    }else if (!strcmp(argv[1], "swipe")) {
        if (argc < 6 || argc > 8) {
            PRINT_USAGE;
            return 0;
        }
        
        float duration = 0.3f;
        if (argc == 6) {
            CGPoint fromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint toPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }else if (argc == 7) {
            CGPoint fromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint toPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            duration = atof(argv[6]);
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }else if (argc == 8) {
            CGPoint pfromPoint = CGPointMake(atoi(argv[2]), atoi(argv[3]));
            CGPoint ptoPoint = CGPointMake(atoi(argv[4]), atoi(argv[5]));
            
            CGPoint fromPoint = [SimulateTouch STWindowToScreenPoint:pfromPoint withOrientation:atoi(argv[7])];
            CGPoint toPoint = [SimulateTouch STWindowToScreenPoint:ptoPoint withOrientation:atoi(argv[7])];
            
            duration = atof(argv[6]);
            [SimulateTouch simulateSwipeFromPoint:fromPoint toPoint:toPoint duration:duration];
        }
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode , duration+0.1f, NO);
    }else if (!strcmp(argv[1], "button")) {
        if (argc != 4) {
            PRINT_USAGE;
            return 0;
        }
        
        int button = atoi(argv[2]);
        int state  = atoi(argv[3]);
        
        [SimulateTouch simulateButton:button state:state];
    }else if(!strcmp(argv[1], "home")){
        [SimulateTouch simulateButton:1 state:1];
        usleep(200);
        [SimulateTouch simulateButton:1 state:0];
    }else if(!strcmp(argv[1], "lock")){
        [SimulateTouch simulateButton:0 state:1];
        usleep(200);
        [SimulateTouch simulateButton:0 state:0];
    }else if(!strcmp(argv[1], "home-double-click")){
        [SimulateTouch simulateButton:1 state:1];
        usleep(200);
        [SimulateTouch simulateButton:1 state:0];
        usleep(1000);
        [SimulateTouch simulateButton:1 state:1];
        usleep(200);
        [SimulateTouch simulateButton:1 state:0];
    }else if(!strcmp(argv[1], "screenshot")){
        [SimulateTouch simulateButton:1 state:1];
        usleep(200);
        [SimulateTouch simulateButton:0 state:1];
        usleep(800);
        [SimulateTouch simulateButton:1 state:0];
        usleep(200);
        [SimulateTouch simulateButton:0 state:0];
    }
    else{
        PRINT_USAGE;
        return 0;
    }
    
    return 0;
}