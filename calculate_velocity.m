function vel = calculate_velocity(prev_pos, new_pos, dt)

vel = norm(new_pos/1000 - prev_pos/1000) / dt;