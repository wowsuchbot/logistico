import { Router, Route } from "@solidjs/router";
import { lazy, Suspense } from "solid-js";

const Dashboard = lazy(() => import("./pages/Dashboard"));
const Orders = lazy(() => import("./pages/Orders"));
const Laborers = lazy(() => import("./pages/Laborers"));

export default function App() {
  return (
    <Router>
      <div class="app">
        <nav class="nav">
          <a href="/">Dashboard</a>
          <a href="/orders">Orders</a>
          <a href="/laborers">Laborers</a>
        </nav>
        <main class="main">
          <Suspense fallback={<p>Loading…</p>}>
            <Route path="/" component={Dashboard} />
            <Route path="/orders" component={Orders} />
            <Route path="/laborers" component={Laborers} />
          </Suspense>
        </main>
      </div>
    </Router>
  );
}
