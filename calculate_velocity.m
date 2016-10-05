function vel = calculate_velocity(prev_pos, new_pos, dt)

vel = abs(double(new_pos)/1000 - double(prev_pos)/1000) / seconds(dt);