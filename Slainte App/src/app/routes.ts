import { createBrowserRouter } from "react-router";
import { Layout } from "./components/Layout";
import { Dashboard } from "./pages/Dashboard";
import { Vitals } from "./pages/Vitals";
import { MedicalTests } from "./pages/MedicalTests";
import { DoctorVisits } from "./pages/DoctorVisits";
import { Prescriptions } from "./pages/Prescriptions";
import { MedicalHistory } from "./pages/MedicalHistory";
import { MoreMenu } from "./pages/MoreMenu";
import { Guidance } from "./pages/Guidance";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Layout,
    children: [
      { index: true, Component: Dashboard },
      { path: "vitals", Component: Vitals },
      { path: "tests", Component: MedicalTests },
      { path: "visits", Component: DoctorVisits },
      { path: "more", Component: MoreMenu },
      { path: "prescriptions", Component: Prescriptions },
      { path: "history", Component: MedicalHistory },
      { path: "guidance", Component: Guidance },
    ],
  },
]);
