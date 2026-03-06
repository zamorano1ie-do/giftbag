import { useState } from "react";
import { BookOpen, Heart, Apple, Moon, Activity, ChevronRight, Lightbulb, Star, ChevronDown } from "lucide-react";
import { C } from "../constants/colors";

const categories = [
  { id: "all", label: "All" },
  { id: "heart", label: "Heart" },
  { id: "diabetes", label: "Diabetes" },
  { id: "nutrition", label: "Nutrition" },
  { id: "sleep", label: "Sleep" },
];

const tips = [
  {
    category: "heart",
    icon: Heart,
    color: C.primary,
    bg: C.pink100,
    title: "Blood Pressure Management",
    summary: "Simple daily steps to keep your blood pressure in a healthy range.",
    content: "• Walk for at least 30 minutes on most days of the week.\n• Reduce salt intake — aim for less than 6g per day.\n• Limit alcohol to 1–2 units per day maximum.\n• Practice relaxation techniques such as deep breathing or gentle yoga.\n• Take your Lisinopril at the same time each morning.\n• Monitor your blood pressure at home and record readings.",
    tag: "For your hypertension",
    priority: true,
  },
  {
    category: "diabetes",
    icon: Activity,
    color: "#5a88c4",
    bg: "#e8f2ff",
    title: "Managing Pre-Diabetes",
    summary: "Early action can prevent or delay the onset of Type 2 Diabetes.",
    content: "• Losing even 5–7% of body weight can significantly reduce diabetes risk.\n• Choose whole grains over refined carbohydrates.\n• Spread carbohydrate intake evenly throughout the day.\n• Check blood glucose levels as advised by Dr. Chen.\n• Take Metformin with meals to reduce stomach side effects.\n• Aim for 150 minutes of moderate activity per week.",
    tag: "For your pre-diabetes",
    priority: true,
  },
  {
    category: "nutrition",
    icon: Apple,
    color: "#5dab6f",
    bg: "#eef8f1",
    title: "Heart-Healthy Eating",
    summary: "A balanced diet supports your blood pressure and cholesterol goals.",
    content: "• Eat plenty of fruits and vegetables — aim for 5–7 portions daily.\n• Choose oily fish (salmon, mackerel) 2x per week for omega-3 fatty acids.\n• Limit saturated fats — choose lean meats and low-fat dairy.\n• Add oats, beans, and lentils which help lower cholesterol.\n• Avoid processed foods, takeaways, and ready meals where possible.\n• Drink 6–8 glasses of water daily.",
    tag: "Nutrition",
    priority: false,
  },
  {
    category: "sleep",
    icon: Moon,
    color: "#8b6fa0",
    bg: "#f3eef8",
    title: "Better Sleep for Better Health",
    summary: "Good sleep helps manage blood pressure and blood sugar levels.",
    content: "• Aim for 7–8 hours of sleep per night.\n• Keep a consistent bedtime and wake time — even on weekends.\n• Avoid screens (phone, TV) for 1 hour before bed.\n• Keep your bedroom cool, dark, and quiet.\n• Avoid caffeine after 2pm.\n• A warm bath before bed can help you relax.",
    tag: "Wellbeing",
    priority: false,
  },
  {
    category: "heart",
    icon: Heart,
    color: C.primary,
    bg: C.pink100,
    title: "Cholesterol & Heart Health",
    summary: "Understanding and managing your cholesterol with Atorvastatin.",
    content: "• Atorvastatin works best taken in the evening — this is when your body makes most cholesterol.\n• Never stop taking Atorvastatin without speaking to Dr. Chen first.\n• Grapefruit and grapefruit juice can interact with Atorvastatin — avoid these.\n• Report any unexplained muscle pain or weakness to your doctor immediately.\n• A Mediterranean-style diet is particularly beneficial for cholesterol.",
    tag: "For your cholesterol",
    priority: false,
  },
];

const faqs = [
  { q: "Can I take all my medications together?", a: "Lisinopril is best taken in the morning, Atorvastatin in the evening, and Metformin with meals. Always follow your prescription instructions. Contact Dr. Chen if you have any concerns." },
  { q: "What should I do if I miss a dose?", a: "If you remember the same day, take it as soon as you can. If it's nearly time for your next dose, skip the missed one. Never double up doses. Contact your pharmacist if unsure." },
  { q: "When should I go to A&E or call 999?", a: "For chest pain, severe shortness of breath, sudden severe headache, facial drooping, arm weakness or speech problems — call 999 immediately. These could indicate a heart attack or stroke." },
  { q: "How often should I check my blood pressure at home?", a: "Dr. Chen recommends checking twice daily (morning and evening) for the first few weeks, then as needed. Record all readings to bring to your next appointment." },
];

export function Guidance() {
  const [selectedCategory, setSelectedCategory] = useState("all");
  const [expandedTip, setExpandedTip] = useState<number | null>(0);
  const [expandedFaq, setExpandedFaq] = useState<number | null>(null);

  const filteredTips = tips.filter((t) => selectedCategory === "all" || t.category === selectedCategory);

  return (
    <div style={{ background: C.bg, paddingBottom: "24px", fontFamily: '"Open Sans", sans-serif' }}>
      {/* Header */}
      <div style={{ background: `linear-gradient(135deg, ${C.sageDark} 0%, #6a8066 100%)`, padding: "20px 20px 32px", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: "-20px", right: "-20px", width: "100px", height: "100px", borderRadius: "50px", background: "rgba(255,255,255,0.1)" }} />
        <h1 style={{ color: "white", fontSize: "22px", fontWeight: "700", margin: "0 0 4px" }}>Health Guidance</h1>
        <p style={{ color: "rgba(255,255,255,0.8)", fontSize: "13px", margin: 0 }}>Personalised tips & education</p>
      </div>

      {/* Personalised Banner */}
      <div style={{ margin: "-16px 16px 0", position: "relative", zIndex: 10, marginBottom: "16px" }}>
        <div style={{ background: C.card, borderRadius: "18px", padding: "14px 16px", boxShadow: "0 4px 16px rgba(84,70,58,0.1)", display: "flex", alignItems: "flex-start", gap: "10px" }}>
          <div style={{ width: "36px", height: "36px", borderRadius: "18px", background: C.sage50, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
            <Lightbulb size={18} color={C.sageDark} />
          </div>
          <div>
            <p style={{ fontSize: "14px", fontWeight: "700", color: C.textPrimary, margin: "0 0 2px" }}>Tips tailored for you, Margaret</p>
            <p style={{ fontSize: "13px", color: C.textSecondary, margin: 0, lineHeight: "1.4" }}>Based on your conditions: Hypertension, Pre-diabetes & Cholesterol</p>
          </div>
        </div>
      </div>

      {/* Category Filter */}
      <div style={{ padding: "0 16px 16px", overflowX: "auto" }}>
        <div style={{ display: "flex", gap: "8px" }}>
          {categories.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setSelectedCategory(cat.id)}
              style={{
                padding: "7px 14px",
                borderRadius: "20px",
                border: "none",
                cursor: "pointer",
                background: selectedCategory === cat.id ? C.sageDark : C.card,
                color: selectedCategory === cat.id ? "white" : C.textSecondary,
                fontSize: "13px",
                fontWeight: selectedCategory === cat.id ? "600" : "400",
                fontFamily: '"Open Sans", sans-serif',
                whiteSpace: "nowrap",
                boxShadow: "0 1px 6px rgba(84,70,58,0.08)",
                transition: "all 0.2s",
              }}
            >
              {cat.label}
            </button>
          ))}
        </div>
      </div>

      {/* Tips */}
      <div style={{ padding: "0 16px" }}>
        {filteredTips.map((tip, i) => {
          const Icon = tip.icon;
          const isExpanded = expandedTip === i;
          return (
            <div
              key={i}
              style={{
                background: C.card,
                borderRadius: "18px",
                marginBottom: "10px",
                overflow: "hidden",
                boxShadow: "0 2px 12px rgba(84,70,58,0.07)",
                borderTop: tip.priority ? `3px solid ${tip.color}` : "none",
              }}
            >
              <button
                onClick={() => setExpandedTip(isExpanded ? null : i)}
                style={{ width: "100%", padding: "14px 16px", background: "none", border: "none", cursor: "pointer", fontFamily: '"Open Sans", sans-serif', textAlign: "left" }}
              >
                <div style={{ display: "flex", alignItems: "flex-start", gap: "12px" }}>
                  <div style={{ width: "40px", height: "40px", borderRadius: "12px", background: tip.bg, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, marginTop: "2px" }}>
                    <Icon size={20} color={tip.color} />
                  </div>
                  <div style={{ flex: 1 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "3px" }}>
                      <p style={{ fontSize: "14px", fontWeight: "700", color: C.textPrimary, margin: 0 }}>{tip.title}</p>
                      {tip.priority && <Star size={13} fill={tip.color} color={tip.color} />}
                    </div>
                    <p style={{ fontSize: "12px", color: C.textSecondary, margin: "0 0 4px" }}>{tip.summary}</p>
                    <span style={{ fontSize: "11px", fontWeight: "600", color: tip.color, background: tip.bg, padding: "2px 8px", borderRadius: "6px" }}>{tip.tag}</span>
                  </div>
                  <ChevronDown
                    size={16}
                    color={C.textSecondary}
                    style={{ transform: isExpanded ? "rotate(180deg)" : "none", transition: "transform 0.25s", flexShrink: 0, marginTop: "4px" }}
                  />
                </div>
              </button>

              {isExpanded && (
                <div style={{ padding: "0 16px 16px", borderTop: `1px solid ${C.border}` }}>
                  <div style={{ background: C.bg, borderRadius: "12px", padding: "12px 14px", marginTop: "10px" }}>
                    {tip.content.split("\n").map((line, li) => (
                      <p key={li} style={{ fontSize: "13px", color: C.textPrimary, margin: li > 0 ? "6px 0 0" : 0, lineHeight: "1.6" }}>{line}</p>
                    ))}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* FAQs */}
      <div style={{ padding: "16px 16px 0" }}>
        <p style={{ fontSize: "16px", fontWeight: "700", color: C.textPrimary, margin: "0 0 12px" }}>Frequently Asked Questions</p>
        {faqs.map((faq, i) => (
          <div key={i} style={{ background: C.card, borderRadius: "14px", marginBottom: "8px", overflow: "hidden", boxShadow: "0 2px 8px rgba(84,70,58,0.05)" }}>
            <button
              onClick={() => setExpandedFaq(expandedFaq === i ? null : i)}
              style={{ width: "100%", padding: "14px 16px", background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "space-between", gap: "8px", fontFamily: '"Open Sans", sans-serif' }}
            >
              <p style={{ fontSize: "14px", fontWeight: "600", color: C.textPrimary, margin: 0, textAlign: "left" }}>{faq.q}</p>
              <ChevronDown
                size={16}
                color={C.textSecondary}
                style={{ transform: expandedFaq === i ? "rotate(180deg)" : "none", transition: "transform 0.25s", flexShrink: 0 }}
              />
            </button>
            {expandedFaq === i && (
              <div style={{ padding: "0 16px 14px", borderTop: `1px solid ${C.border}` }}>
                <p style={{ fontSize: "13px", color: C.textPrimary, margin: "10px 0 0", lineHeight: "1.6" }}>{faq.a}</p>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Disclaimer */}
      <div style={{ padding: "16px 16px 0" }}>
        <div style={{ background: C.sage50, borderRadius: "14px", padding: "12px 14px", border: `1px solid ${C.sage}44` }}>
          <p style={{ fontSize: "12px", color: C.sageDark, margin: 0, lineHeight: "1.5" }}>
            <strong>⚠️ Important:</strong> This guidance is for educational purposes only and supplements — but does not replace — professional medical advice. Always consult Dr. Chen or your healthcare team before making changes to your treatment.
          </p>
        </div>
      </div>
    </div>
  );
}
