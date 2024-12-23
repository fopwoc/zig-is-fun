const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");

const MAX_BUNNIES: comptime_int = 1024 * 64;
const MAX_BATCH_ELEMENTS: comptime_int = 1024 * 8;

const Bunny = struct {
    position: ray.Vector2,
    speed: ray.Vector2,
    color: ray.Color,
};

pub fn main() void {
    const screen_width = 800;
    const screen_height = 450;

    ray.InitWindow(screen_width, screen_height, "raylib [textures] example - bunnymark");
    defer ray.CloseWindow();

    // Load bunny texture
    const tex_bunny = ray.LoadTexture("./wabbit_alpha.png");
    defer ray.UnloadTexture(tex_bunny);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var bunnies = allocator.alloc(Bunny, MAX_BUNNIES) catch unreachable;
    defer allocator.free(bunnies);

    var bunnies_count: usize = 0;

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        // Update
        if (ray.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT)) {
            // Create more bunnies
            var i: usize = 0;
            while (i < 100 and bunnies_count < MAX_BUNNIES) : (i += 1) {
                bunnies[bunnies_count].position = ray.GetMousePosition();
                bunnies[bunnies_count].speed.x = @as(f32, @floatFromInt(ray.GetRandomValue(-250, 250))) / 60.0;
                bunnies[bunnies_count].speed.y = @as(f32, @floatFromInt(ray.GetRandomValue(-250, 250))) / 60.0;
                bunnies[bunnies_count].color = ray.Color{
                    .r = @intCast(ray.GetRandomValue(50, 240)),
                    .g = @intCast(ray.GetRandomValue(80, 240)),
                    .b = @intCast(ray.GetRandomValue(100, 240)),
                    .a = 255,
                };
                bunnies_count += 1;
            }
        }

        // Update bunnies
        var i: usize = 0;
        while (i < bunnies_count) : (i += 1) {
            bunnies[i].position.x += bunnies[i].speed.x;
            bunnies[i].position.y += bunnies[i].speed.y;

            if (((bunnies[i].position.x + @as(f32, @floatFromInt(tex_bunny.width)) / 2.0) > @as(f32, @floatFromInt(ray.GetScreenWidth()))) or
                ((bunnies[i].position.x + @as(f32, @floatFromInt(tex_bunny.width)) / 2.0) < 0)) bunnies[i].speed.x *= -1;
            if (((bunnies[i].position.y + @as(f32, @floatFromInt(tex_bunny.height)) / 2.0) > @as(f32, @floatFromInt(ray.GetScreenHeight()))) or
                ((bunnies[i].position.y + @as(f32, @floatFromInt(tex_bunny.height)) / 2.0 - 40) < 0)) bunnies[i].speed.y *= -1;
        }

        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.RAYWHITE);

        i = 0;
        while (i < bunnies_count) : (i += 1) {
            ray.DrawTexture(tex_bunny, @intFromFloat(bunnies[i].position.x), @intFromFloat(bunnies[i].position.y), bunnies[i].color);
        }

        ray.DrawRectangle(0, 0, screen_width, 40, ray.BLACK);
        ray.DrawText(ray.TextFormat("bunnies: %i", @as(c_int, @intCast(bunnies_count))), 120, 10, 20, ray.GREEN);
        ray.DrawText(ray.TextFormat("batched draw calls: %i", @as(c_int, @intCast(1 + bunnies_count / MAX_BATCH_ELEMENTS))), 320, 10, 20, ray.MAROON);

        ray.DrawFPS(10, 10);
    }
}
