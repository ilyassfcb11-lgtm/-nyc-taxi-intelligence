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
  { borough: "Manhattan", trips: 6563944, revenue: 171948126, tripShare: 86.5, revenueShare: 74.7 },
  { borough: "Queens", trips: 656540, revenue: 44967617, tripShare: 8.7, revenueShare: 19.5 },
  { borough: "Brooklyn", trips: 287906, revenue: 10169721, tripShare: 3.8, revenueShare: 4.4 },
  { borough: "Bronx", trips: 69662, revenue: 2622090, tripShare: 0.9, revenueShare: 1.1 },
  { borough: "Unknown", trips: 8503, revenue: 313343, tripShare: 0.1, revenueShare: 0.1 },
  { borough: "Staten Island", trips: 549, revenue: 26957, tripShare: 0.0, revenueShare: 0.0 }
];

const pressureZones = [
  { borough: "Brooklyn", zone: "Brooklyn Navy Yard", pressure: 18.93, trips: 1365 },
  { borough: "Queens", zone: "Woodside", pressure: 15.81, trips: 3632 },
  { borough: "Queens", zone: "Maspeth", pressure: 13.57, trips: 3249 },
  { borough: "Queens", zone: "Flushing Meadows-Corona Park", pressure: 13.01, trips: 1806 },
  { borough: "Brooklyn", zone: "Greenpoint", pressure: 12.48, trips: 11096 }
];

const revenueZones = [
  { borough: "Queens", zone: "JFK Airport", trips: 285717, revenue: 22943560, value: 80.30 },
  { borough: "Queens", zone: "LaGuardia Airport", trips: 199374, revenue: 14298484, value: 71.72 },
  { borough: "Manhattan", zone: "Midtown Center", trips: 313407, revenue: 8684599, value: 27.71 },
  { borough: "Manhattan", zone: "Upper East Side South", trips: 367459, revenue: 8177216, value: 22.25 },
  { borough: "Manhattan", zone: "Upper East Side North", trips: 323917, revenue: 7367403, value: 22.74 }
];

const yieldZones = [
  { borough: "Queens", zone: "JFK Airport", trips: 285717, revenue: 22943560, value: 80.30 },
  { borough: "Queens", zone: "LaGuardia Airport", trips: 199374, revenue: 14298484, value: 71.72 },
  { borough: "Queens", zone: "East Elmhurst", trips: 16749, revenue: 1141717, value: 68.17 },
  { borough: "Queens", zone: "Sunnyside", trips: 11951, revenue: 533393, value: 44.63 },
  { borough: "Queens", zone: "Long Island City/Hunters Point", trips: 14010, revenue: 575865, value: 41.10 }
];

const hours = [
  228699, 149322, 98441, 68525, 56657, 66513, 130017, 237714,
  311463, 329164, 335190, 363216, 392826, 405220, 446902, 458713,
  438440, 482078, 491225, 435193, 427369, 460168, 435484, 340280
].map((trips, hour) => ({ hour, trips }));

const routeAlerts = [
  { route: "Penn Station/Madison Sq West -> Times Sq/Theatre District", trips: 13309, score: 0.65 },
  { route: "Lenox Hill East -> Upper East Side North", trips: 12683, score: 0.68 },
  { route: "Penn Station/Madison Sq West -> Union Sq", trips: 10278, score: 0.81 },
  { route: "Yorkville East -> Upper East Side South", trips: 9247, score: 0.71 },
  { route: "Upper East Side South -> Times Sq/Theatre District", trips: 6843, score: 0.72 },
  { route: "Murray Hill -> Penn Station/Madison Sq West", trips: 6368, score: 0.57 }
];

const topRoutes = [
  { route: "JFK Airport -> Outside of NYC", trips: 13247, revenue: 1643357, score: 1.44 },
  { route: "JFK Airport -> Times Sq/Theatre District", trips: 12099, revenue: 1175390, score: 0.95 },
  { route: "LaGuardia Airport -> Times Sq/Theatre District", trips: 11374, revenue: 944988, score: 1.27 },
  { route: "Upper East Side South -> Upper East Side North", trips: 55358, revenue: 895086, score: 1.98 },
  { route: "Upper East Side North -> Upper East Side South", trips: 46947, revenue: 785873, score: 2.01 }
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
  revenue: "#168553"
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
    return `
      <div class="bar-row">
        <div class="bar-topline">
          <span class="bar-label">${options.label(row)}</span>
          <span class="bar-value">${options.caption(row)}</span>
        </div>
        <div class="bar-track">
          <div class="bar-fill" style="--w: ${percent(value, maxValue)}; --bar-color: ${options.color};"></div>
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
    label: (row) => row.zone,
    value: (row) => row[sortMode],
    caption: (row) => {
      if (sortMode === "revenue") return formatMoney.format(row.revenue);
      if (sortMode === "trips") return formatNumber.format(row.trips);
      return row.priority.toFixed(2);
    }
  });
}

function renderBoroughMix() {
  document.getElementById("boroughMix").innerHTML = boroughs.map((row) => `
    <div class="mix-row">
      <div class="mix-topline">
        <span>${row.borough}</span>
        <span>${formatNumber.format(row.trips)} trips</span>
      </div>
      <div class="mix-bars">
        <div class="mix-track">
          <span class="trip-fill" style="--w: ${row.tripShare}%;"></span>
        </div>
        <div class="mix-track">
          <span class="revenue-fill" style="--w: ${row.revenueShare}%;"></span>
        </div>
      </div>
      <div class="mix-legend">
        <span><i class="legend-dot trip-fill"></i>${row.tripShare.toFixed(1)}% trips</span>
        <span><i class="legend-dot revenue-fill"></i>${row.revenueShare.toFixed(1)}% revenue</span>
      </div>
    </div>
  `).join("");
}

function renderRankList(containerId, rows, options) {
  document.getElementById(containerId).innerHTML = rows.map((row, index) => `
    <div class="rank-row">
      <div>
        <strong class="rank-name">${index + 1}. ${options.name(row)}</strong>
        <span class="rank-meta">${options.meta(row)}</span>
      </div>
      <span class="rank-value">${options.value(row)}</span>
    </div>
  `).join("");
}

function renderHourly() {
  const maxTrips = Math.max(...hours.map((row) => row.trips));
  document.getElementById("hourlyBars").innerHTML = hours.map((row) => `
    <div class="hour-column ${row.hour === 18 ? "peak" : ""}" title="${row.hour}:00 - ${formatNumber.format(row.trips)} trips">
      <div class="hour-stick" style="--h: ${percent(row.trips, maxTrips)};"></div>
      <div class="hour-label">${row.hour}</div>
    </div>
  `).join("");
}

function renderRoutes() {
  document.getElementById("routeAlerts").innerHTML = routeAlerts.map((row) => `
    <div class="route-row">
      <div>
        <strong class="route-name">${row.route}</strong>
        <span class="route-meta">${formatNumber.format(row.trips)} trips</span>
      </div>
      <div class="route-value">Score ${row.score.toFixed(2)}</div>
    </div>
  `).join("");
}

function renderDashboard() {
  renderBoroughMix();
  renderPriority();
  renderHourly();
  renderRoutes();

  renderRankList("pressureList", pressureZones, {
    name: (row) => row.zone,
    meta: (row) => `${row.borough} | ${formatNumber.format(row.trips)} trips`,
    value: (row) => row.pressure.toFixed(2)
  });

  renderRankList("revenueZones", revenueZones, {
    name: (row) => row.zone,
    meta: (row) => `${row.borough} | ${formatNumber.format(row.trips)} trips`,
    value: (row) => formatMoney.format(row.revenue)
  });

  renderRankList("yieldZones", yieldZones, {
    name: (row) => row.zone,
    meta: (row) => `${row.borough} | ${formatMoney.format(row.revenue)}`,
    value: (row) => `$${row.value.toFixed(2)}`
  });

  renderRankList("topRoutes", topRoutes, {
    name: (row) => row.route,
    meta: (row) => `${formatNumber.format(row.trips)} trips | score ${row.score.toFixed(2)}`,
    value: (row) => formatMoney.format(row.revenue)
  });
}

document.getElementById("boroughFilter").addEventListener("change", renderPriority);
document.getElementById("sortMode").addEventListener("change", renderPriority);

renderDashboard();
