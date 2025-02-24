import mongoose, { Schema } from "mongoose";
import mongooseAggregatePaginate from "mongoose-aggregate-paginate-v2";

const likeSchema = new Schema(
  {
    post: {
      type: Schema.Types.ObjectId,
      ref: "Post",
      default: null,
    },
    comment: {
      type: Schema.Types.ObjectId,
      ref: "Comment",
      default: null,
    },
    likedBy: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
);

// Ensure a like is either on a post OR a comment, not both.
likeSchema.pre("save", function (next) {
  if (!this.post && !this.comment) {
    return next(new Error("A like must be associated with either a post or a comment."));
  }
  if (this.post && this.comment) {
    return next(new Error("A like cannot be associated with both a post and a comment."));
  }
  next();
});

// Indexes for faster query performance
likeSchema.index({ post: 1, likedBy: 1 }, { unique: true, sparse: true });
likeSchema.index({ comment: 1, likedBy: 1 }, { unique: true, sparse: true });

likeSchema.plugin(mongooseAggregatePaginate);

export const Like = mongoose.model("Like", likeSchema);
