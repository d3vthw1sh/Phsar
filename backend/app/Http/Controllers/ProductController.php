<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Review;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $page = $request->query('page', 1);

        $products = Product::orderBy('created_at', 'desc')
            ->paginate(10);

        return response()->json([
            'products' => $products->items(),
            'pagination' => [
                'currentPage' => $products->currentPage(),
                'totalPages' => $products->lastPage(),
            ]
        ]);
    }

    // ---------------------------------------------------------
    // SEARCH PRODUCTS
    // ---------------------------------------------------------
    public function search(Request $request)
    {
        $query = $request->query('q', '');
        $category = $request->query('category');
        $minPrice = $request->query('minPrice');
        $maxPrice = $request->query('maxPrice');
        $inStock = $request->query('inStock', false);

        $products = Product::query();

        // Search by name, brand, category, or description
        if (!empty($query)) {
            $products->where(function ($q) use ($query) {
                $q->where('name', 'like', "%{$query}%")
                    ->orWhere('brand', 'like', "%{$query}%")
                    ->orWhere('category', 'like', "%{$query}%")
                    ->orWhere('description', 'like', "%{$query}%");
            });
        }

        // Filter by category
        if (!empty($category) && $category !== 'All') {
            $products->where('category', $category);
        }

        // Filter by price range
        if (!empty($minPrice)) {
            $products->where('price', '>=', (int)$minPrice);
        }
        if (!empty($maxPrice)) {
            $products->where('price', '<=', (int)$maxPrice);
        }

        // Filter by stock
        if ($inStock === 'true' || $inStock === true) {
            $products->where('stock', '>', 0);
        }

        $results = $products->orderBy('created_at', 'desc')->get();

        return response()->json([
            'count' => count($results),
            'products' => $results
        ]);
    }

    public function show($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response("Product not found", 404);
        }

        return response()->json($product);
    }

    public function createReview(Request $request, $id)
    {
        $product = Product::find($id);
        if (!$product) return response("Product not found", 404);

        $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'title' => 'nullable|string',
            'comment' => 'nullable|string'
        ]);

        $user = auth()->user();

        $existing = Review::where('product_id', $id)
            ->where('user_id', $user->id)
            ->first();

        if ($existing) {
            return response("Product already reviewed.", 400);
        }

        Review::create([
            'product_id' => $id,
            'user_id' => $user->id,
            'name' => $user->name,
            'rating' => $request->rating,
            'title' => $request->title,
            'comment' => $request->comment
        ]);

        $total = Review::where('product_id', $id)->count();
        $avg = Review::where('product_id', $id)->avg('rating');

        $product->numberOfReviews = $total;
        $product->rating = $avg;
        $product->save();

        return response("Review added", 200);
    }

    public function deleteReview($productId, $reviewId)
    {
        $review = Review::where('product_id', $productId)
            ->where('id', $reviewId)
            ->first();

        if (!$review) return response("Review not found", 404);

        $review->delete();

        $product = Product::find($productId);
        $total = Review::where('product_id', $productId)->count();
        $avg = Review::where('product_id', $productId)->avg('rating') ?? 0;

        $product->numberOfReviews = $total;
        $product->rating = $avg;
        $product->save();

        return response("Review deleted", 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'images' => 'nullable|array',
            'description' => 'required',
            'brand' => 'required',
            'category' => 'required',
            'price' => 'required|integer',
            'stock' => 'required|integer',
            'productIsNew' => 'boolean',
            'stripeId' => 'nullable|string'
        ]);

        $product = Product::create($request->all());

        return response()->json($product);
    }

    public function update(Request $request, $id)
    {
        $product = Product::find($id);
        if (!$product) return response("Product not found", 404);

        $product->update($request->all());

        return response()->json($product);
    }

    public function destroy($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response("Product not found", 404);
        }

        $product->delete();

        return response("Product deleted", 200);
    }

    // -------------------------
    // GET ALL REVIEWS (ADMIN)
    // -------------------------
    public function allReviews()
    {
        $reviews = Review::with(['product', 'user'])->orderBy('created_at', 'desc')->get();
        return response()->json(['reviews' => $reviews]);
    }
}
