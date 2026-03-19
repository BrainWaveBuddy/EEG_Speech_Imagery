function [ai,samplerate] = initUSBampOnlineUpdate()

%	INITUSBAMPONLINE Initializer for gUSBamp
%
%	update of Adnan Vilic initiation script. This includes all 16 channels


samplerate = 512;
ai = analoginput('guadaq',1);	% guadaq is the data aquisition adaptor from gtec and comes with installation of the amplifier
addchannel(ai,1:16);            % Read from channel 1 to 16

set(ai,'SamplesPerTrigger',inf);
set(ai,'TriggerRepeat',inf);
set(ai,'SampleRate',samplerate);
set(ai,'TriggerType','Immediate');
set(ai,'Mode','Normal');
set(ai,'SlaveMode','Off');

% Apply filters corresponding to sample rate (512 Hz)
% To see filter numbers use gUSBampShowFilter command. Eg. for 128 Hz gUSBampShowFilter(128)
set(ai.Channel(1:16),'BPIndex',78);    % Bandpass 5-30 Hz 8th order Butterworth
set(ai.Channel(1:16),'NotchIndex',4);  % Notch 48-52 Hz 4th order Butterworth

% Start g.USBamp
start(ai);

end
