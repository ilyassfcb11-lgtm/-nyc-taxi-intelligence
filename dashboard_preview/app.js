const priorityZones = [
  { borough: "Manhattan", zone: "Upper East Side South", trips: 367459, revenue: 8177216, priority: 78.5 },
  { borough: "Manhattan", zone: "Midtown Center", trips: 313407, revenue: 8684599, priority: 74.21 },
  { borough: "Manhattan", zone: "Upper East Side North", trips: 323917, revenue: 7367403, priority: 73.7 },
  { borough: "Queens", zone: "JFK Airport", trips: 285717, revenue: 22943560, priority: 66.78 },
  { borough: "Manhattan", zone: "Midtown East", trips: 230123, revenue: 6089369, priority: 64.61 },
  { borough: "Manhattan", zone: "Times Sq/Theatre District", trips: 217378, revenue: 6689255, priority: 63.83 },
  { borough: "Manhattan", zone: "East Village", trips: 196852, revenue: 5064091, priority: 62.15 },
  { borough: "Manhattan", zone: "Lincoln Square East", trips: 228102, revenue: 5494122, priority: 61.85 },
  { borough: "Manhattan", zone: "Penn Station/Madison Sq West", trips: 223401, revenue: 6086014, priority: 61.81 }
];

const boroughs = [
  { borough: "Manhattan", trips: 6563944, revenue: 171948126 },
  { borough: "Queens", trips: 656540, revenue: 44967617 },
  { borough: "Brooklyn", trips: 287906, revenue: 10169721 },
  { borough: "Bronx", trips: 69662, revenue: 2622090 },
  { borough: "Unknown", trips: 8503, revenue: 313343 },
  { borough: "Staten Island", trips: 549, revenue: 26957 }
];

const hours = [
  { hour: 18, trips: 491225 },
  { hour: 17, trips: 482078 },
  { hour: 21, trips: 460168 },
  { hour: 15, trips: 458713 },
  { hour: 14, trips: 446902 }
];

const routes = [
  { route: "Penn Station/Madison Sq West -> Times Sq/Theatre District", trips: 13309, score: 0.65 },
  { route: "Lenox Hill East -> Upper East Side North", trips: 12683, score: 0.68 },
  { route: "Penn Station/Madison Sq West -> Union Sq", trips: 10278, score: 0.81 },
  { route: "Yorkville East -> Upper East Side South", trips: 9247, score: 0.71 },
  { route: "Upper East Side South -> Times Sq/Theatre District", trips: 6843, score: 0.72 }
];

const formatNumber = new Intl.NumberFormat("en-US");
const formatMoney = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 0
});

const colors = {
  priority: "#2f6fed",
  trips: "#008b8b",
  revenue: "#188a5a"
};

function percent(value, max) {
  if (!max) return "0%";
  return `${Math.max(4, Math.round((value / max) * 100))}%`;
}

function renderBars(containerId, rows, options) {
  const container = document.getElementById(containerId);
  const maxValue = Math.max(...rows.map(options.value));
  container.innerHTML = rows.map((row) => {
    const value = options.value(row);
    const label = options.label(row);
    const caption = options.caption(row);
    const width = percent(value, maxValue);
    return `
      <div class="bar-row">
        <div class="bar-topline">
          <span class="bar-label">${label}</span>
          <span class="bar-value">${caption}</span>
        </div>
        <div class="bar-track">
          <div class="bar-fill" style="--w: ${width}; --bar-color: ${options.color};"></div>
        </div>
      </div>
    `;
  }).join("");
}

function renderPriority() {
  const borough = document.getElementById("boroughFilter").value;
  const sortMode = document.getElementById("sortMode").value;
  const filtered = priorityZones
    .filter((row) => borough === "All" || row.borough === borough)
    .sort((a, b) => b[sortMode] - a[sortMode]);

  renderBars("priorityBars", filtered, {
    color: colors[sortMode],
    label: (row) => `${row.zone}`,
    value: (row) => row[sortMode],
    caption: (row) => {
      if (sortMode === "revenue") return formatMoney.format(row.revenue);
      if (sortMode === "trips") return formatNumber.format(row.trips);
      return row.priority.toFixed(2);
    }
  });
}

function renderStaticCharts() {
  renderBars("tripBars", boroughs, {
    color: colors.trips,
    label: (row) => row.borough,
    value: (row) => row.trips,
    caption: (row) => formatNumber.format(row.trips)
  });

  renderBars("revenueBars", boroughs, {
    color: colors.revenue,
    label: (row) => row.borough,
    value: (row) => row.revenue,
    caption: (row) => formatMoney.format(row.revenue)
  });

  const maxHour = Math.max(...hours.map((row) => row.trips));
  document.getElementById("hourlyBars").innerHTML = hours.map((row) => `
    <div class="hour-card">
      <span>${row.hour}:00 pickup hour</span>
      <strong>${formatNumber.format(row.trips)}</strong>
      <div class="bar-track">
        <div class="bar-fill" style="--w: ${percent(row.trips, maxHour)}; --bar-color: #b7791f;"></div>
      </div>
    </div>
  `).join("");

  document.getElementById("routeAlerts").innerHTML = routes.map((row) => `
    <div class="route-row">
      <div>
        <strong>${row.route}</strong>
        <span>${formatNumber.format(row.trips)} trips</span>
      </div>
      <div class="route-score">Score ${row.score.toFixed(2)}</div>
    </div>
  `).join("");
}

document.getElementById("boroughFilter").addEventListener("change", renderPriority);
document.getElementById("sortMode").addEventListener("change", renderPriority);

renderStaticCharts();
renderPriority();
