import { Head } from "@inertiajs/react";
import Layout from "../../components/Layout";

export default function Home() {
  return (
    <Layout>
      <Head title="Home" />
      <div className="text-center py-20 text-gray-500">
        <p className="text-lg">No videos shared yet. Be the first to share one!</p>
      </div>
    </Layout>
  );
}
