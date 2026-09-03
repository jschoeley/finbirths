# Global constants and functions

# Figure specification ----------------------------------------------------

MyGGplotTheme <-
  function (
    size = 8,
    family = 'sans',
    scaler = 1,
    axis = 'x',
    panel_border = FALSE,
    background_color = 'grey95',
    grid = 'y',
    minor_grid = '',
    show_legend = TRUE,
    ar = NA,
    axis_title_just = 'rt',
    axis_ticks = TRUE
  ) {

    size_med = size*scaler
    size_sml = round(size*0.7)*scaler
    base_linesize = 0.3*scaler

    # justification of axis titles
    xj <- switch(tolower(substr(axis_title_just, 1, 1)), b = 0,
                 l = 0, m = 0.5, c = 0.5, r = 1, t = 1)
    yj <- switch(tolower(substr(axis_title_just, 2, 2)), b = 0,
                 l = 0, m = 0.5, c = 0.5, r = 1, t = 1)

    list(
      theme_minimal(base_size = size_med, base_family = family),
      theme(
        # basic
        text = element_text(color = 'black'),
        line = element_line(linewidth = base_linesize, lineend = 'square'),
        # axis
        axis.title = element_text(size = size_med, face = 'bold'),
        axis.title.x = element_text(hjust = xj),
        axis.title.y = element_text(hjust = yj),
        axis.title.y.right = element_text(hjust = yj, angle = 90),
        axis.text = element_text(size = size_med, color = 'black'),
        # strips
        strip.text = element_text(color = 'black', size = size_med),
        strip.background = element_blank(),
        # plot
        title = element_text(face = 'bold'),
        plot.subtitle = element_text(color = 'black', size = size_med, face = 'bold'),
        plot.caption = element_text(color = 'black', size = size_sml, face = 'plain'),
        plot.background = element_blank(),
        panel.background = element_rect(fill = background_color, colour = NA),
        #plot.margin = unit(c(1, 0.1, 0.5, 0.5), units = 'mm'),
        # grid
        panel.grid = element_blank()
      ),
      if (isTRUE(axis_ticks)) {
        theme(axis.ticks = element_line(linewidth = rel(0.5), color = 'black'))
      },
      if (identical(grid, 'y')) {
        theme(panel.grid.major.y =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (identical(grid, 'x')) {
        theme(panel.grid.major.x =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (identical(grid, 'xy') | identical(grid, 'yx')) {
        theme(panel.grid.major.y =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'),
              panel.grid.major.x =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (identical(minor_grid, 'y')) {
        theme(panel.grid.minor.y =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (identical(minor_grid, 'x')) {
        theme(panel.grid.minor.x =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (identical(minor_grid, 'xy') | identical(grid, 'yx')) {
        theme(panel.grid.minor.y =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'),
              panel.grid.minor.x =
                element_line(linewidth = base_linesize, linetype = 3, color = 'grey80'))
      },
      if (isTRUE(panel_border)) {
        theme(
          panel.border =
            element_rect(fill = NA)
        )
      },
      if (!isTRUE(show_legend)) {
        theme(legend.position = 'none')
      },
      if (axis == 'x') {
        theme(
          axis.line.x = element_line(linetype = 1, color = 'black')
        )
      },
      if (axis == 'y') {
        theme(
          axis.line.y = element_line(linetype = 1, color = 'black')
        )
      },
      if (axis == 'xy') {
        theme(
          axis.line = element_line(linetype = 1, color = 'black')
        )
      },
      if (!is.na(ar)) {
        theme(
          aspect.ratio = ar
        )
      }
    )
  }

# Global functions figures ------------------------------------------------

ExportSVG <- function (
    figure,
    filename,
    width = 170,
    height = 100,
    scale = 1,
    dpi = 300
) {
  ggsave(
    filename = filename,
    figure,
    device = svglite::svglite,
    fix_text_size = FALSE,
    width = width,
    height = height,
    units = 'mm',
    scale = scale,
    dpi = dpi
  )
}
