import { useState } from "react";
import { Activity, Plus, TrendingDown, TrendingUp, Minus, Heart } from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";
import { C } from "../constants/colors";

const weightData = [
  { month: "Sep", weight: 75.0 },
  { month: "Oct", weight: 74.2 },
  { month: "Nov", weight: 73.5 },
  { month: "Dec", weight: 73.0 },
  { month: "Jan", weight: 72.5 },
  { month: "Feb", weight: 72.0 },
  { month: "Mar", weight: 72.0 },
];

const bpData = [
  { month: "Sep", systolic: 138, diastolic: 88 },
  { month: "Oct", systolic: 135, diastolic: 86 },
  { month: "Nov", systolic: 132, diastolic: 84 },
  { month: "Dec", systolic: 130, diastolic: 83 },
  { month: "Jan", systolic: 129, diastolic: 82 },
  { month: "Feb", systolic: 128, diastolic: 82 },
  { month: "Mar", systolic: 128, diastolic: 82 },
];

const recentReadings = [
  { date: "Today, 7:30 AM", weight: "72.0 kg", bp: "128/82", hr: "74" },
  { date: "Yesterday", weight: "72.0 kg", bp: "130/83", hr: "76" },
  { date: "Mar 3", weight: "72.1 kg", bp: "129/82", hr: "72" },
  { date: "Mar 1", weight: "72.2 kg", bp: "131/84", hr: "75" },
];

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div style={{ background: "white", border: `1px solid ${C.border}`, borderRadius: "10px", padding: "8px 12px", boxShadow: "0 4px 12px rgba(0,0,0,0.1)", fontFamily: '"Open Sans", sans-serif' }}>
        <p style={{ margin: 0, fontWeight: "600", color: C.textPrimary, fontSize: "13px" }}>{label}</p>
        {payload.map((p: any, i: number) => (
          <p key={i} style={{ margin: "2px 0 0", fontSize: "12px", color: p.color }}>{p.name}: {p.value}{p.unit}</p>
        ))}
      </div>
    );
  }
  return null;
};

export function Vitals() {
  const [activeChart, setActiveChart] = useState<"weight" | "bp">("weight");
  const [showAddForm, setShowAddForm] = useState(false);

  const bmi = (72.0 / (1.63 * 1.63)).toFixed(1);

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, ${C.sage} 0%, ${C.sageDark} 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>My Vitals</h1>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>Last updated today</p>
          </div>
          <button
            onClick={() => setShowAddForm(true)}
            style={{ background: "rgba(255,255,255,0.25)", border: "none", borderRadius: "14px", padding: "10px 16px", cursor: "pointer", display: "flex", alignItems: "center", gap: "6px" }}
          >
            <Plus size={18} color="white" />
            <span style={{ color: "white", fontSize: "14px", fontWeight: "600", fontFamily: '"Open Sans", sans-serif' }}>Log</span>
          </button>
        </div>
      </div>

      {/* Key Metrics */}
      <div style={{ margin: "-16px 16px 0", position: "relative", zIndex: 10 }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "8px" }}>
          {[
            { label: "Weight", value: "72.0", unit: "kg", trend: "down", color: C.primary, bg: C.pink50 },
            { label: "Height", value: "163", unit: "cm", trend: "stable", color: C.sageDark, bg: C.sage50 },
            { label: "BMI", value: bmi, unit: "", trend: "down", color: "#8b6fa0", bg: "#f3eef8" },
          ].map((m) => (
            <div key={m.label} style={{ background: m.bg, borderRadius: "16px", padding: "14px 10px", border: `1px solid ${m.color}22` }}>
              <p style={{ fontSize: "11px", color: C.textSecondary, margin: "0 0 4px", fontWeight: "600", textTransform: "uppercase", letterSpacing: "0.3px" }}>{m.label}</p>
              <p style={{ fontSize: "22px", fontWeight: "700", color: C.textPrimary, margin: "0 0 4px", lineHeight: 1 }}>
                {m.value}
                <span style={{ fontSize: "12px", color: C.textSecondary, fontWeight: "400" }}> {m.unit}</span>
              </p>
              <div style={{ display: "flex", alignItems: "center", gap: "3px" }}>
                {m.trend === "down" && <TrendingDown size={13} color="#5dab6f" />}
                {m.trend === "up" && <TrendingUp size={13} color="#e05050" />}
                {m.trend === "stable" && <Minus size={13} color={C.textSecondary} />}
                <span style={{ fontSize: "11px", color: m.trend === "down" ? "#5dab6f" : m.trend === "up" ? "#e05050" : C.textSecondary }}>
                  {m.trend === "down" ? "Improving" : m.trend === "up" ? "Rising" : "Stable"}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Blood Pressure & Heart Rate */}
      <div style={{ padding: "16px 16px 0" }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "10px" }}>
          <div style={{ background: C.card, borderRadius: "16px", padding: "14px", boxShadow: "0 2px 10px rgba(84,70,58,0.07)" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "8px" }}>
              <Heart size={16} color={C.primary} fill={C.primary} />
              <span style={{ fontSize: "12px", color: C.textSecondary }}>Blood Pressure</span>
            </div>
            <p style={{ fontSize: "24px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>128<span style={{ fontSize: "16px", fontWeight: "500" }}>/82</span></p>
            <p style={{ fontSize: "11px", margin: 0, color: "#c47c2f", fontWeight: "600" }}>mmHg · Slightly high</p>
          </div>
          <div style={{ background: C.card, borderRadius: "16px", padding: "14px", boxShadow: "0 2px 10px rgba(84,70,58,0.07)" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "6px", marginBottom: "8px" }}>
              <Activity size={16} color="#5dab6f" />
              <span style={{ fontSize: "12px", color: C.textSecondary }}>Heart Rate</span>
            </div>
            <p style={{ fontSize: "24px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>74 <span style={{ fontSize: "14px", fontWeight: "400", color: C.textSecondary }}>bpm</span></p>
            <p style={{ fontSize: "11px", margin: 0, color: "#5dab6f", fontWeight: "600" }}>Normal range</p>
          </div>
        </div>
      </div>

      {/* Chart */}
      <div style={{ padding: "16px 16px 0" }}>
        <div style={{ background: C.card, borderRadius: "20px", padding: "16px", boxShadow: "0 2px 12px rgba(84,70,58,0.07)" }}>
          {/* Chart toggle */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
            <p style={{ fontSize: "15px", fontWeight: "700", color: C.textPrimary, margin: 0 }}>Trends</p>
            <div style={{ display: "flex", background: C.bg, borderRadius: "10px", padding: "3px" }}>
              {(["weight", "bp"] as const).map((type) => (
                <button
                  key={type}
                  onClick={() => setActiveChart(type)}
                  style={{
                    padding: "5px 12px",
                    borderRadius: "8px",
                    border: "none",
                    cursor: "pointer",
                    fontSize: "12px",
                    fontWeight: "600",
                    fontFamily: '"Open Sans", sans-serif',
                    background: activeChart === type ? C.primary : "transparent",
                    color: activeChart === type ? "white" : C.textSecondary,
                    transition: "all 0.2s",
                  }}
                >
                  {type === "weight" ? "Weight" : "BP"}
                </button>
              ))}
            </div>
          </div>

          <ResponsiveContainer width="100%" height={160}>
            {activeChart === "weight" ? (
              <LineChart key="weight-chart" data={weightData} margin={{ top: 5, right: 5, left: -20, bottom: 0 }}>
                <CartesianGrid key="wgrid" strokeDasharray="3 3" stroke={C.border} />
                <XAxis key="wxaxis" dataKey="month" tick={{ fontSize: 11, fill: C.textSecondary, fontFamily: '"Open Sans", sans-serif' }} />
                <YAxis key="wyaxis" domain={[70, 76]} tick={{ fontSize: 11, fill: C.textSecondary, fontFamily: '"Open Sans", sans-serif' }} />
                <Tooltip key="wtooltip" content={<CustomTooltip />} />
                <Line key="weight-line" type="monotone" dataKey="weight" stroke={C.primary} strokeWidth={2.5} dot={{ fill: C.primary, r: 4 }} name="Weight" />
              </LineChart>
            ) : (
              <LineChart key="bp-chart" data={bpData} margin={{ top: 5, right: 5, left: -20, bottom: 0 }}>
                <CartesianGrid key="bgrid" strokeDasharray="3 3" stroke={C.border} />
                <XAxis key="bxaxis" dataKey="month" tick={{ fontSize: 11, fill: C.textSecondary, fontFamily: '"Open Sans", sans-serif' }} />
                <YAxis key="byaxis" domain={[70, 145]} tick={{ fontSize: 11, fill: C.textSecondary, fontFamily: '"Open Sans", sans-serif' }} />
                <Tooltip key="btooltip" content={<CustomTooltip />} />
                <Line key="systolic-line" type="monotone" dataKey="systolic" stroke={C.primary} strokeWidth={2.5} dot={{ fill: C.primary, r: 3 }} name="Systolic" />
                <Line key="diastolic-line" type="monotone" dataKey="diastolic" stroke={C.primaryLight} strokeWidth={2.5} dot={{ fill: C.primaryLight, r: 3 }} name="Diastolic" />
              </LineChart>
            )}
          </ResponsiveContainer>
        </div>
      </div>

      {/* Recent Readings */}
      <div style={{ padding: "16px 16px 0" }}>
        <p style={{ fontSize: "16px", fontWeight: "700", color: C.textPrimary, margin: "0 0 12px" }}>Recent Readings</p>
        <div style={{ background: C.card, borderRadius: "16px", overflow: "hidden", boxShadow: "0 2px 10px rgba(84,70,58,0.06)" }}>
          <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr 1fr 1fr", padding: "10px 14px", background: C.bg, borderBottom: `1px solid ${C.border}` }}>
            {["Date", "Weight", "BP", "HR"].map((h) => (
              <span key={h} style={{ fontSize: "11px", fontWeight: "600", color: C.textSecondary, textTransform: "uppercase", letterSpacing: "0.5px" }}>{h}</span>
            ))}
          </div>
          {recentReadings.map((r, i) => (
            <div
              key={i}
              style={{
                display: "grid",
                gridTemplateColumns: "2fr 1fr 1fr 1fr",
                padding: "12px 14px",
                borderBottom: i < recentReadings.length - 1 ? `1px solid ${C.border}` : "none",
                alignItems: "center",
              }}
            >
              <span style={{ fontSize: "13px", color: C.textPrimary }}>{r.date}</span>
              <span style={{ fontSize: "13px", color: C.textPrimary, fontWeight: "500" }}>{r.weight}</span>
              <span style={{ fontSize: "13px", color: C.primary, fontWeight: "500" }}>{r.bp}</span>
              <span style={{ fontSize: "13px", color: "#5dab6f", fontWeight: "500" }}>{r.hr}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Add Reading Modal */}
      {showAddForm && (
        <div style={{ position: "absolute", inset: 0, zIndex: 150, background: "rgba(84,70,58,0.5)", display: "flex", alignItems: "flex-end" }}>
          <div style={{ background: C.card, borderRadius: "24px 24px 0 0", padding: "20px", width: "100%", boxShadow: "0 -4px 30px rgba(0,0,0,0.15)" }}>
            <div style={{ display: "flex", justifyContent: "center", marginBottom: "16px" }}>
              <div style={{ width: "40px", height: "4px", background: C.border, borderRadius: "2px" }} />
            </div>
            <h3 style={{ margin: "0 0 16px", color: C.textPrimary, fontSize: "18px", fontWeight: "700" }}>Log New Reading</h3>
            {[
              { label: "Weight (kg)", placeholder: "e.g. 72.0", type: "number" },
              { label: "Blood Pressure (mmHg)", placeholder: "e.g. 128/82", type: "text" },
              { label: "Heart Rate (bpm)", placeholder: "e.g. 74", type: "number" },
            ].map((field) => (
              <div key={field.label} style={{ marginBottom: "12px" }}>
                <label style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, display: "block", marginBottom: "6px" }}>{field.label}</label>
                <input
                  type={field.type}
                  placeholder={field.placeholder}
                  style={{ width: "100%", padding: "12px 14px", border: `1.5px solid ${C.border}`, borderRadius: "12px", fontSize: "16px", fontFamily: '"Open Sans", sans-serif', color: C.textPrimary, background: C.bg, outline: "none", boxSizing: "border-box" }}
                />
              </div>
            ))}
            <div style={{ display: "flex", gap: "10px", marginTop: "8px" }}>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 1, padding: "14px", background: C.bg, border: `1.5px solid ${C.border}`, borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: C.textSecondary, cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Cancel</button>
              <button onClick={() => setShowAddForm(false)} style={{ flex: 2, padding: "14px", background: C.sage, border: "none", borderRadius: "14px", fontSize: "15px", fontWeight: "600", color: "white", cursor: "pointer", fontFamily: '"Open Sans", sans-serif' }}>Save Reading</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}