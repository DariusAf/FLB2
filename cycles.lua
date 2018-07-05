normal_body = {
  personnality = {
    walkcycle_xrange = 150,
    walkcycle_yrange = 40,
    leg_length = 165,
    cycle_speed = 0.7,
    torso_dypos_base = 157,
    torso_dypos_range = 10,
    torso_dypos_phase = 0.35,
    torso_dr_base = 5,
    torso_dr_range = 2,
    torso_dr_phase = 0.35
  },
  f1_walk = {
    {t = 0.25, dx = 0.1, dy = 1, int = 'sinout'},
    {t = 0.5, dx = 0.4, dy = 0, int = 'sinin'},
    {t = 0.75, dx = 0, dy = 0, int = 'lin'},
    {t = 1, dx = -0.6, dy = 0, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = 0, dy = 0, int = 'lin'},
    {t = 0.5, dx = -0.6, dy = 0, int = 'lin'},
    {t = 0.75, dx = 0.1, dy = 1, int = 'sinout'},
    {t = 1, dx = 0.4, dy = 0, int = 'sinin'},
  }
}

confident_body = {
  personnality = {
    walkcycle_xrange = 200,
    walkcycle_yrange = 50,
    leg_length = 165,
    cycle_speed = 0.9,
    torso_dypos_base = 160,
    torso_dypos_range = 15,
    torso_dypos_phase = 0.35,
    torso_dr_base = -5,
    torso_dr_range = 5,
    torso_dr_phase = 0.35
  },
  f1_walk = {
    {t = 0.25, dx = 0, dy = 1, int = 'sinin'},
    {t = 0.5, dx = 0.4, dy = 0, int = 'sinout'},
    {t = 0.75, dx = 0, dy = 0, int = 'lin'},
    {t = 1, dx = -0.6, dy = 0, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = 0, dy = 0, int = 'lin'},
    {t = 0.5, dx = -0.6, dy = 0, int = 'lin'},
    {t = 0.75, dx = 0, dy = 1, int = 'sinin'},
    {t = 1, dx = 0.4, dy = 0, int = 'sinout'},
  }
}

disco_body = {
  personnality = {
    walkcycle_xrange = 200,
    walkcycle_yrange = 70,
    leg_length = 165,
    cycle_speed = 0.7,
    torso_dypos_base = 160,
    torso_dypos_range = 10,
    torso_dypos_phase = 0.6,
    torso_dr_base = -5,
    torso_dr_range = 10,
    torso_dr_phase = 0.3
  },
  f1_walk = {
    {t = 0.25, dx = 0, dy = 1, int = 'sinout'},
    {t = 0.5, dx = 0.5, dy = 0, int = 'sinout'},
    {t = 0.75, dx = 0, dy = 0, int = 'lin'},
    {t = 1, dx = -0.5, dy = 0, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = 0, dy = 0, int = 'lin'},
    {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
    {t = 0.75, dx = 0, dy = 1, int = 'sinout'},
    {t = 1, dx = 0.5, dy = 0, int = 'sinout'},
  }
}

running_body = {
  personnality = {
    walkcycle_xrange = 150,
    walkcycle_yrange = 70,
    leg_length = 165,
    cycle_speed = 0.9,
    torso_dypos_base = 157,
    torso_dypos_range = 25,
    torso_dypos_phase = 0.55,
    torso_dr_base = 10,
    torso_dr_range = 8,
    torso_dr_phase = 0.35
  },
  f1_walk = {
    {t = 0.25, dx = 0.4, dy = 0, int = 'sinout'},
    {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
    {t = 0.75, dx = -0.7, dy = 0.8, int = 'sinin'},
    {t = 1.0, dx = 0, dy = 0.5, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = -0.7, dy = 0.8, int = 'sinin'},
    {t = 0.5, dx = 0, dy = 0.5, int = 'lin'},
    {t = 0.75, dx = 0.4, dy = 0, int = 'sinout'},
    {t = 1.0, dx = -0.5, dy = 0, int = 'lin'},
  }
}

-- NOT DONE
limp_body = {
  f1_walk = {
    {t = 0.25, dx = 0.1, dy = 0, int = 'lin'},
    {t = 0.5, dx = 0.3, dy = 0, int = 'lin'},
    {t = 0.75, dx = 0, dy = 0, int = 'lin'},
    {t = 1, dx = -0.4, dy = 0, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = 0, dy = 0, int = 'lin'},
    {t = 0.7, dx = -0.5, dy = 0, int = 'lin'},
    {t = 0.9, dx = 0, dy = 1, int = 'sinin'},
    {t = 1, dx = 0.5, dy = 0, int = 'sinout'},
  }
}

-- NOT DONE
discrete_body = {
  f1_walk = {
    {t = 0.1, dx = -0.2, dy = 1, int = 'sin'},
    {t = 0.4, dx = 0.2, dy = 1, int = 'lin'},
    {t = 0.5, dx = 0.5, dy = 0, int = 'sin'},
    {t = 0.75, dx = 0, dy = 0, int = 'lin'},
    {t = 1, dx = -0.5, dy = 0, int = 'lin'},
  },
  f2_walk = {
    {t = 0.25, dx = 0, dy = 0, int = 'lin'},
    {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
    {t = 0.6, dx = -0.2, dy = 1, int = 'sin'},
    {t = 0.9, dx = 0.2, dy = 1, int = 'lin'},
    {t = 1, dx = 0.5, dy = 0, int = 'sin'},
  }
}
