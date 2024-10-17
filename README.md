Getting started with baremetal programming


# Before starting

So you want to start baremetal programming but you are sure where to start. You look online and see chip schematics, complex diagrams, unfamiliar dictionary and get discouraged. Does that sound familiar? Fear not! In this this short introduction to baremetal programming I plan on helping you get your feet wet. Take your first step and see where it leads you.

**Prerequisites:**

So what do you have to have before reading this? All of the skills below are not a must but they would greatly help you follow along:

- C programming language basics

- Assembly programming basics

- Boolean algebra (bit manipulation)

- Interest in learning (this is a must)

**Hardware prerequisites:**

I recommend that you do not buy anything before reading through this introduction atleast once, so you get a better picture of whether this is something truly fit for you or not. However if you do want to follow along then this is what I will be using:

- A machine with Linux

  - Any machine and OS would work but I am using Linux so the burden of making it work on other OS is on the reader. Naturally the code we write is not OS specific but the compile pipeline is. Apple users usually can simply follow along by brew installing everything I will be using.

- An Arduino Uno R3 Board and its type a/b usb cable

- A breadboard

- Eight breadboard LED lights

- Breadboard wires

- Four breadboard jumper wires

- Eight  150-350 OHM resistors (as many as LED lights) for help finding the strength consult: <https://www.calculator.net/resistor-calculator.html> 

- A breadboard button switch

- A breadboard buttonswitch

Below is a picture of all the needed components:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeHUPqJkIIL73XSByZu8tJTP7zdE0pe0GsDijpQaUNqOY_rWEXMGfNzyoBrLoF-3nqpI1nyzya9oDVOUNdozEOAROcyKfe_CEmAXFxnmazEJyHcF2UYK-_Moat7WwNJfyaUh0kMxb-3lG_Tidm-XbBP0blG?key=9rAVAIlGuPmBaTfId18n7w)

All the code will be available over at Github at:

<https://github.com/Doxakis1/IntroductionToBareMetal>


# Installing the compiler

We need to install the following three packages:

- gcc-avr

- avr-libc

- avrdude

In the github repository you will find an installation.sh file which you can run that installs all the dependencies.

NOTE: if you are using a different package manager make sure to update the scripts package manager variables

After installing the avr compiler and closing/re-opening your terminal, if you type ‘avr-’ and press SHIFT you should see the following options:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXep_2H2nptptM0aqeKAdpJXJIiG_Viz2q5vjboofNu0129QDPdUIMV9GSGFbugM3_qWlUHwDXz8nLJumNDNY-H8kmHhXBcJfANszgHe0Zkh-wKmWYPi9RhzBau5FwkNz_47feH2Z9nH2tO4zwc21vqW8fM?key=9rAVAIlGuPmBaTfId18n7w)

This means you have all the tools needed to start the baremetal programming!


# Why no Arduino IDE

If you have programmed with arduino before or you have seen any other beginner arduino tutorials you might have come across the Arduino IDE (integrated developer environment). The IDE is extremely useful for getting started and doing small Arduino projects as it provides out-of-the-box functionality. However this is an introduction to baremetal programming so we are not going to be using the IDE, instead we will be coding things ourselves!


# What is an Arduino Uno R3

The Arduino Uno R3 is a microcontroller. It is widely used by beginners, hobbyists, and professionals for prototyping and learning electronics.

The core of the Arduino Uno is the ATmega328P microcontroller, which contains a CPU, memory (flash, SRAM, EEPROM), and input/output pins, all in one chip. This is the ‘brain’ of the Arduino and handles the execution of the code uploaded to it. ATmega328P is self-sufficient, meaning that it contains all the necessary components (CPU, memory, I/O) on a single chip to perform tasks without needing a full operating system or external peripherals (unlike a general-purpose computer). 

The programmer of the ATmega328P has full control over everything in relation to the chip, all the memory, all peripherals and all the processing power it holds. This inherently means that unlike a traditional computer with a running operating system and kernel, you are not restricted or safeguarded from doing anything you please. This means that you have full control and like uncle Ben would say, with great power comes great responsibility. 

Memory management, resource management and interrupt logic is all up to you. If you make a mistake, you do not have a safeguard, you’re doomed. This is in my opinion what makes baremetal programming so fun, you learn how everything works from the ground up and you get to carefully craft code that serves the purpose of your project.


# The scary documentation

Through-out this introduction I will be using two important resources:

1. ATmega328P documentation (<https://ww1.microchip.com/downloads/aemDocuments/documents/MCU08/ProductDocuments/DataSheets/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf> )

2. AVR Instruction Set Manual (<http://ww1.microchip.com/downloads/en/DeviceDoc/AVR-InstructionSet-Manual-DS40002198.pdf> )

3. AVR-GCC Manual (<https://gcc.gnu.org/wiki/avr-gcc> )

I understand that those two files look extremely intimidating and of course we will not be discussing everything written in them, however my goal is to teach you and show you how I fetched the information about what I am teaching you in the hopes that in the future you will be able to find things on your own.

LET US START


# Lesson00: Light the world up

Like in many programming languages the first program you write is a ‘hello world’ program, baremetal has a similar ‘first light on’ project. We will be doing this project, and all the rest projects, both in AVR assembly and C


## THEORY:

**The registers:**

If you have programmed assembly before, perhaps in an OS like linux you have been introduced to registers. Registers are the fastest memory that can be accessed by the cpu. In modern CPUs these registers are not mapped in physical memory, however that has not always been the case and is certainly not the case with the ATmega328p. All the registers in the ATmega328p live in addressable physical memory.

If we inspect the ATmega328P documentation on page 18, we will find figure 7.2 that looks like this:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcyq7Nv1t_IfbRhcSICIhNemnX0wgopabu2UcxuH9xJArqJkFfN_plZ4Rjbx6EoDgIpaGgI1rXV-3u501DhYzjOznfEVoFr_dNDADRs6sPPomLtE6Egpu0jiJEOdTrsT3et2XCXXwfrQTlbcAXyDHk7Filj?key=9rAVAIlGuPmBaTfId18n7w)

This is the our memory map, the bread and butter of baremetal programming. Everything we need can be done by manipulating these addresses from 0x0000 to 0x08FF. 

As the figure shows, the first addresses 0x0000 - 0x001F are the 32 8-bit registers of our processor. That means that unlike other assembly languages we are free to name our registers however we want. However as we can see in the AVR Instruction Set Manual , they usually denote registers by R(num) so register one would be R1 and is just the address of 0x00.

As a C programmer you might have gotten a heart attack… DID WE JUST RAWDOG ADDRESS 0x00??? Yes… yes we did!

All the memory is ours, there are no restrictions, and even better the memory is not virtualized, it is all pure physical real memory addresses. Below is a figure from the ATmega328p documentation page 12 that shows the naming of the registers:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdHAj3VXQWxBDfLdMwkZg3yWRSxoEC-1KEiyf2wSkBCftNbA6JFrOHqnTdeJ7Z2S935aE9IA0KR3eR_rzwio2u8Zu7Q3W6P27fTyUoOz2QT0IlAZ1JePB6VyeymfxBsksC0Wo2EF8cyfscKO4hBUTusPNr6?key=9rAVAIlGuPmBaTfId18n7w)

**The peripherals:**

If we look at the Figure 7.2 again we will see that after the general purpose registers are some memory addresses called ‘I/O Registers’:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcyq7Nv1t_IfbRhcSICIhNemnX0wgopabu2UcxuH9xJArqJkFfN_plZ4Rjbx6EoDgIpaGgI1rXV-3u501DhYzjOznfEVoFr_dNDADRs6sPPomLtE6Egpu0jiJEOdTrsT3et2XCXXwfrQTlbcAXyDHk7Filj?key=9rAVAIlGuPmBaTfId18n7w)

What exactly are those?

Well those are the addresses where our peripherals are mapped, every external device is mapped on those 64 bytes between 0x0020 and 0x005F. On the ATmega328P documentation on page 72, we find more information about the addresses and their purpose but don’t worry we will come back to this.

**How does communication happen:**

Majority of the devices are I/O (Input and Output) that means that you can send them data, and they can also send you data back. Obviously there are some devices that are unidirectional meaning you can only get data to flow in one direction, but for our introduction purposes let us discuss bidirectional devices. How does the device know if it is supposed to be sending data or receiving data? Well it happens with electricity of course!

There are specific addresses in our physical memory called Data Direction Registers. These locations dictate whether the device is in send mode, or receive mode. 

Still a bit confused? Don’t worry, it will become clear once we get into the first example of coding.

**Clock cycles:**

Every electronic device that has a processor has a clock cycle. If processors were humen, clock cycles would be their heart beats… and they beat fast… the ATmega328p runs at 16Mhz which means its heartbeat is 16 000 000 times per second. Yes you saw the zeros correctly. And as crazy as this sounds, modern cpus consider that speed laughable as they beat at billions of times per second.

Each clock cycle, electrical mechanics advance the program's execution forward. If we look at the AVR Instruction manual on page 18 (table 5.2) we will see that each ATmega328p instruction takes a specific amount of cycles to be executed. Some take one cycle like the ADD instruction, some take three cycles like the JMP instruction. That means that per second we can perform 16 000 000 ADD instructions or 5 333 333 JMP instructions. These are not always 100% accurate but quite accurate nevertheless.

**Let us take a closer look at the microcontroller:\
\
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfP9IbTb6TBDUf8n7nojC8kr92reDKlTrz5pBVcjvMPiEQGq0BU1ELn-hCWfJIBIDpGO85yAATjX77qM6bnU85VhEP_0v7LMzudWOlcP-7c-bRPXyfFUTghx4wQtv9MkHkQRI5CZI4BAWA-kEyNPuRbbC8G?key=9rAVAIlGuPmBaTfId18n7w)****

Actually let us take an even closer look right above the ‘A’ letter of the ‘Arduino’ text:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcIT-ZxFqbIBU39YaLwYAgnlr6r9x_8U7745yFhoLSv1Zsg94k8LJAWGKRKTQtrLmNq4o5wuR0azQlFJpBw_j29PbGuivaiJ0a1UK4SktY_7qFhoxyuk63iNvVFDLMoZpr-ZU4_ZvEkNA5UTdG7p9PCAB9v?key=9rAVAIlGuPmBaTfId18n7w)

You see that ‘L’? Well that L is a tiny LED, a tiny light! But how can we access it? Well below is a nice clear image that shows us what each pin/location is:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfULU6ZhcCMcFw3ZFAoHkB1JwXyutsqVDjuTJTCeZsKyrN6EEXvdfkWLEthnoNJnTX-ZDvp7Uzy-rAT9QQS7loYpG9IoycVzYgZnM04tJQSdPEhiWX7rIBVX2W8ouhNFZzaMiFVWsmDaCj1udbtikzRLXqm?key=9rAVAIlGuPmBaTfId18n7w)

From that image although, admittedly maybe not as clearly as we would hope, we can see that L lies on PB5 also 13 also SCK. Although these names refer to the same location, how we user the location dictates which naming we want to use. We will be calling it PB5 or Port B pin 5. To make this light glow we need to do 2 things, first we have to make the pin writable, so make the data direction flow be towards the pin and then we have to write into the pin.

Let us start first by setting the pin to write mode. On the ATmega328P documentation page 72 we will find the PORTB and DDRB registers:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfowEyM97n2G8OOY9_wMGIXWt7k3ecUzDJFL7jpuzOu66eXam2dfT5-1hiwyVC8q3rxFkJNN0U-H1cu7iaFpYddaw5_sGUIirvrW_jtUwLDv7zDKkbesqNMslOfz6hviyoSm7lpYyqe_M9hL9bix-eSWfji?key=9rAVAIlGuPmBaTfId18n7w)

As we can see they exist at memory location 0x25 and 0x24 respectively if we look at the number inside the parenthesis. The number before the parenthesis is the registers offset from the 32 general purpose registers. We use the number outside the parentheses when we use instructions that require I/O registers.

As the name Data Direction Register implies, this register controls the direction of the flow of data of the PORT B pins. In order for us to turn the light on, we have to first set DDB5 high (put a 1 in that bits location) and after that we can set PORTB5 high (put a 1 in that bits location) .The following assembly code (Lesson00/assembly/main.asm) does exactly that:\
\
NOTE: even though we know that registers and everything else on the ATmega328P is memory mapped, we still respect the AVR instruction set and use naming R0 - R31 for all instructions that take registers to help the readers. We also name our I/O registers as per ATmega328p documentation.

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeafYj1NTPUg7AjlqtahOuwY9VTWoHcCaCQ7T1_HbOTXKlSTA2_C2M-KMc6GC0Vft1g5lX4325y8tGmMdEAmqA-rmi4wK_l0DY-qoXQvdsppS5u85t70igfTT6wcTfk8GKkoobN1tlXzHy5K8HRsy1cv68?key=9rAVAIlGuPmBaTfId18n7w)

if we run ‘make upload’ using the makefile provided in the Github repo, our board goes from this:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc69ITL036S28_qo58sFge1yRdmd_34cNnRzyhrRFjStyuxCnvzwBovnHKdxtpD3J4u9V-2UMVKiXYWU_cfHfTgnRl43yh3ldOEqCsocivwwcNZF7rlupmO_BWiEhEz7um9PliIh9ipQ9lGNrCA6fozryg?key=9rAVAIlGuPmBaTfId18n7w)

To this:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd1pB8LI8dNkcitNJmqhLJkCMfHbmOS4HS_dtqKb9W92_f77e0YUhLIRMyHLfYZ-1bTIFaru89q4jPkGTSQHqrvdxhFMb2XwvAxtX0BHS1qZ43ndU9eb0bUP6esBhVTGAhtdbDFuZxZb752YOB-ig2pWH51?key=9rAVAIlGuPmBaTfId18n7w)

Amazingly, we just turned on an LED!

In C we achieve the same result by running the following code:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdB8dE0inS32n3t7Zbr4fssaJESWmmJEKqDhJnm51BcPNtpZf2-uPHepygbeJfW8HTZYqNfQ2WdaJEIxHd5WLO5NnrIGthw9MNuDMaI4u51nek_cne-huo1J2SaWUYqY1Djv04Ab-bMMqQ50RfsRt1GUZA?key=9rAVAIlGuPmBaTfId18n7w)

For the record, in C I am choosing to use \<avr/io,h> only to use the useful macros for the IO registers instead of having to create them myself. I can however make them myself if I wanted to as seen below:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeTPmFw6qNOaB3LcZdrzNyANaw5PlBsAdoPNo2jGn8Pc02yK-tR7QJ0vvRME4ifXgPJbda1Ae_E_ESuI_WGRf0-dJZh-xoDa4j68lmzCDM6akVUMW92y4gCMfWuc0eVenfLEPWt4PwEgSlQIGLH1DdL7qey?key=9rAVAIlGuPmBaTfId18n7w)

Congratulations you just learned how to make a light go on in baremetal! Let’s see what else we can learn to do in the next 3 lessons!


# Lesson01: Making the light blink

## THEORY:

**Timers and counters:**

Majority of microcontrollers have integrated chips for time-keeping. The ATmega328P is no exception, it has three ways to count time built into it! If we take a look at the ATmega328P documentation on page 74, we will see the 3 timer modes provided. Timers are super useful as they are extremely accurate. However, we are not going to be using timer… at least for our assembly program… The reason why we are not going to use them is that they easy once you understand how they work (understand interruprts and so on..) but they might be hard enough to demotivate you from continuing forward with this introduction. Instead of timers we will be making our own scuffed timers!

**Clock cycles to the rescue:**

Remember when in the earlier theory lesson we learned that instructions take a specific amount of cycles? We will be using this knowledge to make a simple timer in assembly! Given 16 000 000 cycles happen per second, if we do some instruction that takes one cycle for 16 000 000 times, by the time we are done, 1 second should have gone by.

We will be looking at the following 3 instructions from the AVR Instruction Manual:

LDI - 1 cycle

DEC - 1 cycle

CP - 1 cycle

BRNE - 1 / 2 cycles

RJMP - 2 

RET - 4 / 5 cycles

Using these instructions we can create a loop that should take 500ms (0.5 seconds) with the following code:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXftJe6fXlHNiXcWDfdoIleWMg2lWj0mpKvfj0GhQhaYuqpsHevVO3UOBvYgP8yHXK2PgfC9-IPMgCdEcv774nvWY4m5xieB6g6JaHAy1UHXdVDUyrXsSi_f5TsERNzatPDiV0Ms0Y64BFRZfao7SsDYFLm_?key=9rAVAIlGuPmBaTfId18n7w)\
 

Let us examine how we got the 500ms time. You can skip this part and just trust me if you want :P if you do not want to see the maths.

FORMULA START --->

The formula is:

time\_in\_sec = total\_Cycles / m\_CPU

total\_cycles = loop1\_total\_cycles

main\_total\_cycles =  1 + 1 + 31 \* ( 1 + 1 + 2+ loop1\_total\_cycles)

loop1\_total\_cycles =  254 \* (1 + 1 + 2 + 1 + loop2\_total\_cycles)

loop2\_total\_cycles =  254 \* (1 + 1 + 2)

No we can start solving backwards:

loop2\_total\_cycles = 1016

loop1\_total\_cycles =  254 \* (1 + 1 + 2 + 1 + 1016) = 259334

 

total\_cycles = main\_total\_cycles =  1 + 1 + 31 \* ( 1 + 1 + 2+ 259334) = 8039480

time\_in\_sec  = 8039480 / 16000000 =  0.50s

FORMULA END---->

Now that we have a 500ms timer, we can add it to our code and make the LED blink! First we need to make sure that we set our stack pointer properly. Now that we are going to be making a function call we need to make sure our stack pointer is pointing to the correct place so that when we push the return address to the stack, it is at the correct place. Inspecting page 14 of the ATmega328P documentation we see that:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdNv403P7Af5nkEb3cs0K_7yBwTilXK9fKDXFao9vPIxuu4tpfNtqWdHBdfJHsHKexZawLscxD8gAXcUyH2ZW9_xzhWvCNwA4l3WhtmjCbWWqZc3mNsL4r6-p2RJXUSfMC5Feq6hvTDGZu9qP7YQx9gOFs?key=9rAVAIlGuPmBaTfId18n7w)

And we know from previously (ATmega382p documentation page 74) that RAM is from 0x0100

to 0x08FF so we have to set:

SPH => 0x08

SPL => 0xFF

Our new code (Lesson01/assembly/main.asm) looks like this:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcbiiyDnBoXH6zaVT8dD8kGWekCm0GphhGhXhvSL1TqObYfI5GTKmKMkTq_zFW4Sx6fx2pbC2qToxQ7wLq4ISlGwjg_8w43xktF9hTVR1Gp16_nztSNKF6owa9dX8lD1pg5boLYog22Qj9BKGNOVFDvD6FU?key=9rAVAIlGuPmBaTfId18n7w)

That is a lot of code but now your arduino ‘L’ light should be flickering every 500ms ! LETS GO!

For the C enjoyers we do the same logic in the following way:\
\
NOTE: the compiler can optimise things away from us, that is why we are heavily using the keyword volatile!

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXes75syvVMSuByfxpeNre0e0qZPzJB9cfBKuYgDg9u7aOr7XbGT_gSVNqvtRSb_VV0TKq3OQJdtqvp6PT44U-YgLv5uPf0OjHDAxheAVHKiXucIKzpZvA_XV004u4xcHw-f8Khh-nF8H_mad75j00qkX7W6?key=9rAVAIlGuPmBaTfId18n7w)

This effectively is the exact same logic as in our assembly program but programmed in C. We use the volatile and register keyword to achieve our desired estimated cycles. Once again, in C the compiler does a lot behind the scenes so we do not have entrile control over the assembly generated!


# Lesson02: Time to outside

The last 2 lessons, we learned how to work on our embedded LED , now it is time to spread our wings and go outside, time to work with external peripherals.


## THEORY:

**It is all electricity:**

We have discussed that the ATmega328P is clocking at 16Mhz. But what does that mean for the devices connected to it. Every cycle that that the ATmega328P has an I/O pin set to high, it receives electricity. 5 volts of it.

**LED cannot handle the pressure:**

Because LED lights are small and fragile they cannot support 5v of current, that is why we are in need for resistors. Resistors are pretty cool, as they protect our fragile electronics from harmful amounts of electricity. We will not be going into how electronics work in more details, since we want to keep this fun and interesting. But I recommend you do research if you are interested. BenEater ([www.youtube.com/BenEater](http://www.youtube.com/BenEater) ) ia a great source to look at!

In order to follow what I am going to be doing in this lesson you have to set you breadboard to look like this:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfi0nkhwAS0_yG2BmqFZ6ZEhdFzDr6Oj7kgef6IRxkSppGCVuzu8SvqW9xxFQUK3LwADpGIoabeKbu9HbCA-hx3w9IEYTN-mIwaqsogTuAjoA-B2hMvnTjBpDLwfeckNMTUpYDmCKcQGQIU0djjyLrGuz7H?key=9rAVAIlGuPmBaTfId18n7w)

**Breakdown of the image:**

We have a cable connecting the two (+) lines from each side. (Green cable)

We have a cable connecting the two (-) lines from each side. (Yellow cable)

We have a resistor connected from (-) to the 12th rows jth column \[12]\[j]

We have an LED connected LED SHORT LEG at \[12]\[f] and LED LONG LEG \[12]\[e].

We have a small cable connecting \[12]\[a] and (+)

from now on, I will be referring to (-) as GROUND and (+) POWER

Then we are going to hook our jumper cables on our arduino like this:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfR2_5QRNEB74cq_VLF95JiNntDV2DucxipfMiuYBsMv01yrPIZsEUS7tq6KlKzWZwbZmn0FG_cF2Oa7C5FZigCPkvPDD6-_obUB1yHYj2eAfHU2CpJpEhdje_sOMty_QhStXfYXlQKYKA-NLNg0nILBsbf?key=9rAVAIlGuPmBaTfId18n7w)

Arduino provides with both 3.3 volt and 5 volt current. We will use the 5 volts. it also provides us with 2 grounds so technically we can use both 3.3 volt line and 5 volt line at the same time. To make sure everything works properly we can connect our 5volts line to the breadboard POWER and the ground to the GROUND. When we boot the connect the arduino with the usb to our computer, we should see the LED power on:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfl8mS9lb_TzdKYtzlIF6jtsNGn30emEOkTHB5oItMzahlWwaz0GureLawRk6H2J3Gr4ve8JJQPnYJRcw7hZovKiS0lL0abOyhneUEktLSkXROoPxvMPta07P2FT-NaAa2UKMSgt0wOUaDqjOCxI5-Gi4pn?key=9rAVAIlGuPmBaTfId18n7w)  

 

if the LED does not turn on make sure all your connections are properly inserted and also test the with another LED, the amount of times I have tested with broken LEDs is just sad…

Now that we have everything tested lets swap the arrangement a bit:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXegE5z19OZqPg28btUCUXQGsXW2LTKrCPJDByTxc1QMEae58ZnJPS_xSbIFyA3M2t7Z8xXNhD_U359Beq74MEIfGzLbGcMEUmCx7ruESb7Th5VxSkGxj5geHuw5ffdDATlzfMqnYSqAq49E5DLdix1YD9yW?key=9rAVAIlGuPmBaTfId18n7w)

we used smaller wires to connect the ground to GROUND and 5v to POWER.

We removed the small wire connecting the LED to POWER.

We connected a jumper wire from pin13 of the Arduino to the \[12]\[a] pin on the board.

Now we can run the same code as Lesson01, and our blinking light should be blinking alongside the LED on the board!!!


# Lesson03: Time for a ‘Hello world’

Now we are finally ready to write a proper ‘hello world’ with baremetal!

we first connect 8 LEDs to our board like this:

 ![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXchonRJjfnBc_ngmUOXLZ-FRb0K-GAjxlV1aST7_4TlNwBW1xvvjGeceCCr93L9KCA3SMv1wHZgakmHgaG3jJSzJutphlzZfyQHJjY59Y1eiShGVeEHYoDJ-jIvEA1Ox5kRfnIQksvfFhojvz-3FqS4Udw?key=9rAVAIlGuPmBaTfId18n7w)

We basically added 7 more LED next to our previous LED so now we have 8 LEDs and their resistors from rows 12 to 19.

Next what we are going to do is we are going to connect from \[12] to \[19] all the LED rows to our Arduino to our PORTD like this:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXec1VcDpMvwlkgUgfjfdfpVIP_mtuA7s4XjLtzoGUuA6J8rMCrREFO-1u7EZl7FZD6nMhuB47m0MNbxCXzsdRhdPwHVAqu4gbAdtR3dOn9kmZqK1TK5Lskdg537ph2vJiz7NMkwTJJh5vbFXQEp_GNM9py8?key=9rAVAIlGuPmBaTfId18n7w)

Now, originally I wanted to make a hello world by having the 8 LEDs blink hello world in binary since ascii characters are 8 bits each then it should be possible and I encourage you do that if you have single colour LEDs. However because I have 4 uniques colors, I am going to make them blink one color at a time.

So like before, we have to follow the 3 rules:\
\
Set PORTD Direction Register to OUT, since we are going to be writing the pins.

Figure out what pins each rotation should have lit on, and close the rest.

Set the PORTD to that configuration.

So let’s get coding! Our code files are getting a bit bigger so I am going to break them down in pictures for the this and next lesson. First we are going to look at our assembly (Lesson03/assembly/main.asm)

We are going to look at the ATmega328P page 73:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdvyfdrfX0DhmrGEbDCOYLSroRsPduXPtt-l5Ej_tEDsbsWQNEPHpwRal6ceKfr0MXhIIY8AxxHHzL8cJvFCe9ZpcFtKuPNRR9ilK7WXrbA6vaX7LBS6q153pHoKJDV52hN2rXe-LtGy-14c1Gms9_JQMwb?key=9rAVAIlGuPmBaTfId18n7w)

Hence we are going to add the following to our main.asm:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXceN1BsHQC4OeeXbi7gAyHundz1jZ6vZn13qMsNTaPCBdepqGx_gpXVMf4Nft4BZmWhD8xeG5shcTDNk21sJdaZhho7W4NbSjCgoxAizwEJ8LyBEmnHPPuc9lVVIFeq_JLxLdgRFVaKH64eIBto40gWjtYm?key=9rAVAIlGuPmBaTfId18n7w)

Then in our SETUP we are going to set all bits of DDRD high since we are going to use all of them:\
\
&#x20;![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcvC0B2Xvd329oAOvrmA6XCtYzoHkayxjYxgXQE-GppFJT34KrTRuCZoBSH1jwKRiISSeZ0KcyaVEhr7B_Fu8ttErxl1xUd0zPertHr2rdPGWfFp5k67vANTcjnXuRcHM4wOym1lZMDgQ8gGsx3niPa8UOW?key=9rAVAIlGuPmBaTfId18n7w)

Then we make a small loop to loop through the colours:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdJ0_dmfAYVcnuWra1ZMk_N7uO0sYmJD1tHlNg-UV6L-FlWBqgB9fBFLnorZhEfUQtPliD3Ak_da7FgFDlEXJvh5_T5MLBG1d6KawcSLEDNN6ZzMwoQiifzakGpu_-dDwWSBSPsmZW1ouIFAig9U7no0qsd?key=9rAVAIlGuPmBaTfId18n7w)

Compile and upload to your board an be amazed as the lights switch on in a sequence:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcYbmnkVb44qxcx9HnmRJUtDLpboGhzEIWZClj_Pwu9D9olEgl1KUIQKlgB1vUZp0xKTmDT5P6xNIa8o_9BPBIFY1yEWZXr6rjmQ0wtbpDgx33dqjWm1akcC548FVPBzPcOvRF3hoMTCtLyJjsUZxQF_E4?key=9rAVAIlGuPmBaTfId18n7w)![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfNUV_8EGCEmzV1FbkJQpHGIjsMnyFU4rDJXEiapupSKwpV57QtkEkVdr6it25xeWr6wswlV_Mwl0o9eAIYiAFc8K35e9T67exo3SG2U2QgBFGCpaUmxWb0LKb8spxr4xC6jflif1qSk-INY_GJSkTrB_Qt?key=9rAVAIlGuPmBaTfId18n7w)

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXf6crIOIH3KW6iYjM-WoV_SqA_Vq4sgdMUthgBgk0xv7lXG7n_gks3FwxV_8im6h1AJS6wcW0Y5yV7Y0lHQ5PDr87qhsz4M4t-n5TEAX55zVmitpYHpJj6wMJd4JmB1VWmxtjhaSryDkmfj6IyLRJBzwA6r?key=9rAVAIlGuPmBaTfId18n7w)![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeBBQUmSyzKuOdZD6Xt8vZbnjKY6LmOXh547_x5cZzUsCf47yVOcvMAWuKp7X97YJiScMHjHIZRLMtLv2mXJC9FzVHFcYlzGsm7m1FeUN8PU3HlyNKF3aTBn4kT_0BeqwfnQipUwfYXxFjaTQUl3qdxyJaD?key=9rAVAIlGuPmBaTfId18n7w)

Simply beautiful!

The same code in C looks like this:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcJosaGyLe7BiOpumvmM4kHkg5u7yqdUKsY_EmiYk7vb5ev449krHpbMfAc-nZxjMxK9Q4-QVKoPOg3zrZ9uwvOSl8iswLV9gIwR8E8v9Z3Td4N6oyvdDysUCvy5ENkNGU-LQsn-tXplTA-WLbF4ucIcQ?key=9rAVAIlGuPmBaTfId18n7w)

Yeah so much shorter.. I know… that’s why people program in C and not in assembly…


# Lesson04: Getting input

For the last lesson, we worked with sending signal, now I want to show you as the last lesson, how to get data in. For the final lesson we are going to plug the button to your breadboard like this:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe6a_NHXujP9_JKmEEBTA6JW0Xa-XI7jAmoUw7dnlaYRCOjk5WBHKJLs4YGlg-Bipvu1dXGsE7OOTwz4Tz_hBdYgMq-CGZK2hDWxu2AJ36Moq4oMXhXnynHLQK0G2Syx78woWRIf5ShOSpavQRurPSx3c4?key=9rAVAIlGuPmBaTfId18n7w)![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc1MF86fH81FDtKzTBElGAbmoB0t92lpHH8kGmjGjYDjgAaDOEPqawsZTM--W0TCkWAf4BTe-hfgRB3L9chQLViNpzuRD5ToomsxMhSu63zKb9f2vW1VN0N8Z9qch6ZukbWA-xA6BzhR7g06uDHztTXhkKk?key=9rAVAIlGuPmBaTfId18n7w)

So we have now attache button on \[3]\[e] and \[3]\[f], \[5]\[e] and \[5]\[f]. Then we connected \[5]\[e] to POWER and \[3]\[e] to GROUND (in the image you see me connecting it with a cable, CONNECT IT WITH A RESISTOR LOL, I will leave this to show I make mistakes too. But consult the next hardware pictures to see the correct way).

The purpose of the lesson is to learn how read from the button. For this we have attached \[e]\[f] to our trusted PORTB5 <3

We are gonna write a program that when the arduino starts, it reads the pin, then sleeps 500 ms, then checks the pin again, and if the pin state changed, it starts our LED hellow world we wrote in Lesson03!

In assembly it will look like this:

In order to read we get from the ATmega328P documentation the address of PINB

****![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXci1BzwOkHPdod8iizmQSBcGDGkNyDgTlp70WMLJl3aWf2CkcwjENm4NEmpAy_30D5urHHTcIna4d71_bLHj1cb2IzELb-JzpV_ji3CspIhNJpku4p6VW88aaftX3jgKe4vgHa3HV1e6WeGZJVJt3ghq-vM?key=9rAVAIlGuPmBaTfId18n7w)****

and put it in our assembly:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdAIUcmKY0qjEbvURwHF0CJ9v1qbqtIN9E2MRLr7G_c_EdWZGhku4Hds43NoXy0picfgWCB7Fzd-lgVDOo0kOQunQXASX9YSyjxxwb5WVkWR_ofS-VFamyCGvBNvWow_TGPVLCZAl6RBAJjhUFHk7H4tWj3?key=9rAVAIlGuPmBaTfId18n7w)

then we update our setup to look like this:\
\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeYEFf-5N8aOTwtOrzYUxwuqLk8mzI34wjm67gvSiPuHXe1gWfCXZN6Iqt86BQdoXX6zW1wo30n9FPZQMtFFKsZm8Lwc9Fa4LsVkfeXVnrteXF2SYSZfSDmva6CxHS8bn8b7IxdGO1470WcB_tb6FBynTgj?key=9rAVAIlGuPmBaTfId18n7w)

and now we are ready!\
\
when I upload the code to the board the LEDs are turned off. Only when I click down on the switch for a bit does the switching start:\
\
before I press the switch:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdNYYeLn7SrVTniVhJXt7l129zkv9TwUiCtRYaShaYrsS-RnUVMJvKXClEyjM4bsB3GVD3WkH5Wrtv1ZoTmiLk6rDaKUK1iSwFeZTPsEPCWktN3HzTDvdcWkPrFK-xpBLX6SQI-GdID-2RcB7QDoCCxPw?key=9rAVAIlGuPmBaTfId18n7w)

I press the switch down:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXde_y7kuji7Q12C1SQYgxMsmdsfhkdyjAw14P8Pzg6QFBznrZ3JrVy3BM6DA-LB9COSCwk_1lu7FuWlv2lo2cLxCxo3-mGHG-q2JU5kOI_StbRjwpHoshh7fVRwIy2hoNbLk7sxxxgT0BybtxwkcvXfu6E?key=9rAVAIlGuPmBaTfId18n7w)

We can observe the switch is pressed because ‘L’ led turns on!

then the lightswtiching starts again:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXf1r1UEqPtw8trUP7g5n9URFrowTkzmZgljKgJTpYfcIqrBW6CRPYpF6qST6zGNnBrE7tgg2MAsGR-GWkyF6mR5nGsfLUIgdylOEMJbxWE_j80o0SlTNi8680JHh8jarEMcls0rLiGFXh3rkWbW7ABTCok?key=9rAVAIlGuPmBaTfId18n7w)![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd0tUUEskMbaMuH6xF8SF-OJhOwWwBb3ZF1OEomLzdg_aMRRWccLuJBzCmoD4_c_DlYC9kfgeUiprV0mOTCaXztEf8WXTyECsaFDFcaQ1G43yr4qjQQb_NL-aJVPDS9e3qSH4e47eOse9C1QJuXOkhrLC5C?key=9rAVAIlGuPmBaTfId18n7w)

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdesOHvaXXI3ATh5GbPHKpecOp9aUcxY6UAbyCYBvILjTrDHC4arjkrHyIBUeATp7mUx8Bd3ANwoRDmOKu_06KPVuvhwIl6EquroJkLPkXw3AI4nQMD0wX3Y05ThxHbd6LstupbWQIm262FS251PpE3PVZV?key=9rAVAIlGuPmBaTfId18n7w)![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcWnjdMILdJ2awH1b_RBLG6S3aDcwoHdFD_PagVzioPX5wKSJWgiSUiMZvEhmerrl5vB-Yr1H8LpeBwh1Rk_EDItwNmTTmEK8IPlTr930tP07BHf3K2c9OnttAWFojYFiCo8X2wjo6mQphvMdgM2S1MyoJ4?key=9rAVAIlGuPmBaTfId18n7w)

In C the same code looks like this:\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeBIua6bv7br7ICoAt2kA6FACVjTb9jK0zyd942UxCTcUpM0fnF6G7h--aT-8vjsZflc3HhB_871jbQ2MmVRErKsh1kVaPsPyk8IZh3ePsvPJaa1e1rov1-9D8S_Syo2kPzskS36DwbieEnMULERH8Ej_2W?key=9rAVAIlGuPmBaTfId18n7w)

AND THAT IS IT. This was a very simple introduction to baremetal programming. Hopefully this inspired you and motivated you to want to learn more!

Let me know if you wish me to make more guides by contacting me on any of my socials:

Linkedin: <https://www.linkedin.com/in/michail-nektarios-karatzidis-5282862a8/>  

Youtube: <https://www.youtube.com/@CodingWithDox> 

old-school-email: <mike.karat@yahoo.com> 

