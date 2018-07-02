base_f1_walk = {
  {t = 0.25, dx = 0, dy = 1, int = 'sinin'},
  {t = 0.5, dx = 0.5, dy = 0, int = 'sinout'},
  {t = 0.75, dx = 0, dy = 0, int = 'lin'},
  {t = 1, dx = -0.5, dy = 0, int = 'lin'},
}
base_f2_walk = {
  {t = 0.25, dx = 0, dy = 0, int = 'lin'},
  {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
  {t = 0.75, dx = 0, dy = 1, int = 'sinin'},
  {t = 1, dx = 0.5, dy = 0, int = 'sinout'},
}



discrete_f1_walk = {
  {t = 0.1, dx = -0.2, dy = 1, int = 'sin'},
  {t = 0.4, dx = 0.2, dy = 1, int = 'lin'},
  {t = 0.5, dx = 0.5, dy = 0, int = 'sin'},
  {t = 0.75, dx = 0, dy = 0, int = 'lin'},
  {t = 1, dx = -0.5, dy = 0, int = 'lin'},
}
discrete_f2_walk = {
  {t = 0.25, dx = 0, dy = 0, int = 'lin'},
  {t = 0.5, dx = -0.5, dy = 0, int = 'lin'},
  {t = 0.6, dx = -0.2, dy = 1, int = 'sin'},
  {t = 0.9, dx = 0.2, dy = 1, int = 'lin'},
  {t = 1, dx = 0.5, dy = 0, int = 'sin'},
}
