MySidewalk Programming Challenge

Geo Challenge

## How To:

The deliverable is a static HTML page (with a few local assets) and can be viewed in a browser with a simple http server.

1. `python -m http.server 8000`
2. Visit `localhost:8000` in a web browser

## Troubleshooting

- Python command doesn't work
  - The command uses Python3, if you have Python2, then `python -m SimpleHTTPServer 8000` should work.
  - Alternatively, this Ruby command should work: `ruby -run -e httpd . -p 8000`

- Page is blank
  - If you started the server in the root of the repo, `/` (as opposed to `/geo/`), then you may have to direct your browser to localhost:8000/geo
  - Has been tested on latest versions of Chrome, Firefox, & Safari, if possible one of those browsers would be preferred

- D3 isn't working
  - The app actually references a local copy of d3.min.js just in case there were CDN or network connectivity issues on the testing machine.
  - With that being said, there's a chance that a different version of d3.min.js has been cached in your browser and is interfering, a refresh (or opening in an incognito window) should fix it.

## Things I would've done with more time
- I have a feeling the colors aren't accessability/color-blind safe, should probably fix.
- The largest neighborhood (shoal-creek) is such an outlier that it makes some of the visualizations less useful.  I tried to address this by changing the y axis to a log scale on the overall bar chart, but I'm sure there are better solutions.
- Map features:
  - zooming and panning would've been nice (and relatively trivial in d3).
  - transposing on top of google maps / open street maps / or mapbox
- I'm not convinced that the "tooltip bar chart" (the one in the top right) was the best choice in hindsight, maybe would've been better to do some sort of percentage chart (stacked bars?)
- More data, most census stuff is public so I'm sure at least the census tracts could've been enriched with some fun data
- UI flourishes: prettier buttons, prettier headers, prettier stuff

## Prompt
```
The user wants to visualize the following geojson layers (1, 2) together
on a map along with a chart of their commuter population attributes in
an interactive manner.
```
