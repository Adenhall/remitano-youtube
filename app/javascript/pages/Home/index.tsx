import { Head, usePage } from "@inertiajs/react";
import Layout from "../../components/Layout";
import type { SharedProps, VideoItem } from "../../types";

export default function Home() {
  const { videos } = usePage<SharedProps & { videos: VideoItem[] }>().props;

  return (
    <Layout>
      <Head title="Home" />
      <div className="max-w-5xl mx-auto px-4 py-8">
        {videos.length === 0 ? (
          <div className="text-center py-20 text-gray-500">
            <p className="text-lg">No videos shared yet. Be the first to share one!</p>
          </div>
        ) : (
          <div className="space-y-8">
            {videos.map((video) => (
              <div key={video.id} className="flex flex-col sm:flex-row gap-4 border-b border-gray-200 pb-8">
                <div className="sm:shrink-0 sm:w-80">
                  <iframe
                    src={`https://www.youtube.com/embed/${video.youtube_id}`}
                    title={video.title}
                    className="w-full aspect-video rounded"
                    allowFullScreen
                  />
                </div>
                <div className="flex flex-col gap-1 min-w-0">
                  <h2 className="font-semibold text-gray-900 text-lg leading-tight">
                    {video.title}
                  </h2>
                  <p className="text-sm text-gray-500">
                    Shared by <span className="text-gray-700">{video.shared_by}</span>
                  </p>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </Layout>
  );
}
