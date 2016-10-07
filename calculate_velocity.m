function [vel, total] = calculate_velocity(prev_pos, new_pos, dt)

vel = (double(new_pos)/1000 - double(prev_pos)/1000) / seconds(dt);
total = sqrt(vel(1)^2 + vel(2)^2 + vel(3)^2);