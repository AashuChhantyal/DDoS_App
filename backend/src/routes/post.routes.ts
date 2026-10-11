import { Router } from 'express';
import { getDailyPost, completePost } from '../controllers/post.controller';

const router = Router();

router.get('/daily', getDailyPost);
router.post('/:id/complete', completePost);

export default router;