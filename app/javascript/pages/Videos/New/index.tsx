import { useForm } from "@inertiajs/react";
import { Head } from "@inertiajs/react";
import Layout from "../../../components/Layout";

export default function VideosNew() {
  const { data, setData, post, processing, errors } = useForm({
    youtube_url: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    post("/videos");
  }

  return (
    <Layout>
      <Head title="Share a movie" />
      <div className="flex justify-center px-4 py-16">
        <div className="w-full max-w-lg">
          <fieldset className="border border-gray-400 rounded px-6 py-5">
            <legend className="px-2 text-sm text-gray-600">Share a Youtube movie</legend>

            <form onSubmit={handleSubmit} className="space-y-4 mt-2">
              <div className="flex items-center gap-3">
                <label htmlFor="youtube_url" className="text-sm text-gray-700 shrink-0 w-24">
                  Youtube URL:
                </label>
                <input
                  id="youtube_url"
                  type="url"
                  value={data.youtube_url}
                  onChange={(e) => setData("youtube_url", e.target.value)}
                  required
                  placeholder="https://www.youtube.com/watch?v=..."
                  className="flex-1 border border-gray-300 rounded px-3 py-1.5 text-sm focus:outline-none focus:ring-1 focus:ring-gray-400"
                />
              </div>

              {errors.youtube_url && (
                <p className="text-sm text-red-600 ml-28">{errors.youtube_url}</p>
              )}

              <div className="flex justify-center">
                <button
                  type="submit"
                  disabled={processing}
                  className="px-16 py-1.5 border border-gray-900 rounded text-sm hover:bg-gray-100 disabled:opacity-50"
                >
                  Share
                </button>
              </div>
            </form>
          </fieldset>
        </div>
      </div>
    </Layout>
  );
}
