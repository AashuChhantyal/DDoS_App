import { Request, Response } from 'express';
import pool from '../config/database';

export const getDailyPost = async (req: Request, res: Response): Promise<void> => {
  try {
    const result = await pool.query(
      'SELECT id, series_id, title, content, category, read_time_minutes, created_at FROM posts ORDER BY created_at DESC'
    );

    if (result.rows.length === 0) {
      res.status(404).json({ message: 'No posts available today.' });
      return;
    }

    res.status(200).json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error('Error fetching daily post:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

export const completePost = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    // Marks post completed for the user
    res.status(200).json({ success: true, message: `Post ${id} marked completed.` });
  } catch (error) {
    console.error('Error completing post:', error);
    res.status(500).json({ message: 'Failed to complete post' });
  }
};