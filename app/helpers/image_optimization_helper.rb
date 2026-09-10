module ImageOptimizationHelper
  SRCSET_WIDTHS = [ 400, 768, 1536 ].freeze
  OG_IMAGE_WIDTH = 1200
  WEBP_OPTIONS = { format: :webp, saver: { quality: 80 } }.freeze

  def optimized_featured_image_tag(post, **options)
    return unless post.featured_image.attached?

    responsive_image_tag(
      post.featured_image,
      widths: SRCSET_WIDTHS,
      default_width: 768,
      sizes: "(max-width: 768px) 100vw, 768px",
      **options
    )
  end

  # Memoized per post: the head tags and the Article JSON-LD both need it, and
  # building the variant URL is not free.
  def post_og_image_url(post)
    @post_og_image_urls ||= {}
    return @post_og_image_urls[post.id] if @post_og_image_urls.key?(post.id)

    @post_og_image_urls[post.id] = optimized_og_image_url(post)
  end

  def optimized_og_image_url(post)
    return unless post.featured_image.attached?

    blob = post.featured_image.blob
    return rails_storage_proxy_url(post.featured_image) unless blob.image?

    url_for(post.featured_image.variant(resize_to_limit: [ OG_IMAGE_WIDTH, nil ], **WEBP_OPTIONS))
  end

  def optimized_blob_image_tag(blob, in_gallery: false, **options)
    default_width = in_gallery ? 800 : 768

    responsive_image_tag(
      blob,
      widths: in_gallery ? [ 400, 800 ] : [ 400, 768, 1536 ],
      default_width: default_width,
      sizes: in_gallery ? "(max-width: 800px) 100vw, 800px" : "(max-width: 768px) 100vw, 768px",
      fallback: blob.representation(resize_to_limit: in_gallery ? [ 800, 600 ] : [ 1024, 768 ]),
      **options
    )
  end

  def optimized_avatar_tag(identity, size:, **options)
    return unless identity.avatar.attached?

    blob = identity.avatar.blob
    return image_tag(identity.avatar, **options) unless blob.image?

    image_tag(
      identity.avatar.variant(resize_to_fill: [ size, size ], **WEBP_OPTIONS),
      loading: "lazy",
      decoding: "async",
      **options
    )
  end

  private

  def responsive_image_tag(attachable, widths:, default_width:, sizes:, fallback: attachable, **options)
    return image_tag(fallback, **options) unless attachable.image?

    srcset = widths.map { |w|
      variant = attachable.variant(resize_to_limit: [ w, nil ], **WEBP_OPTIONS)
      "#{url_for(variant)} #{w}w"
    }.join(", ")

    default_src = url_for(attachable.variant(resize_to_limit: [ default_width, nil ], **WEBP_OPTIONS))

    image_tag(
      default_src,
      srcset: srcset,
      sizes: sizes,
      loading: "lazy",
      decoding: "async",
      **options
    )
  end
end
